# ----------------------------------------------#
#                  EKS Cluster                  #  
# ----------------------------------------------#

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn      # EKS Cluster Role ARN

  vpc_config {
    subnet_ids         = aws_subnet.public[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_vpc.vpc,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController,
  ]
}

# Jenkins Node Group — only in first subnet (AZ1)
resource "aws_eks_node_group" "jenkins_ng" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-jenkins-ng"
  node_role_arn   = aws_iam_role.worker_node_role.arn          # Worker Node Role ARN
  subnet_ids      = [aws_subnet.public[0].id]                  # pick AZ1
   
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1  
  }

  instance_types = [var.node_group_instance_type]
  capacity_type  = "ON_DEMAND"              

  labels = { "node-role" = "jenkins-node" }                    # Label for Jenkins node to be used in Node Selector

  tags = { Name = "${var.cluster_name}-jenkins-ng" }

  depends_on = [
    aws_eks_cluster.eks
  ]
}

# App Node Group — only in second subnet (AZ2)
resource "aws_eks_node_group" "app_ng" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-app-ng"
  node_role_arn   = aws_iam_role.worker_node_role.arn          # Worker Node Role ARN
  subnet_ids      = [aws_subnet.public[1].id]                  # pick AZ2

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = [var.node_group_instance_type]
  capacity_type  = "ON_DEMAND"

  labels = { "node-role" = "app-node" }                 # Label for App node to be used in Node Selector

  tags = { Name = "${var.cluster_name}-app-ng" }

  depends_on = [
    aws_eks_cluster.eks
  ]
}

resource "aws_eks_addon" "ebs_csi" {                      # EBS CSI Driver Addon to be enabled after cluster creation
  cluster_name      = var.cluster_name
  addon_name        = "aws-ebs-csi-driver"
resolve_conflicts_on_update =  "OVERWRITE"            

  service_account_role_arn = aws_iam_role.ebs_csi_irsa_role.arn     # EBS CSI IRSA Role ARN

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role.ebs_csi_irsa_role,
    kubernetes_service_account.ebs_csi_controller_sa
  ]
}

