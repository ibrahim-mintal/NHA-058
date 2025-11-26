
output "eks_cluster_name" {
  value = var.cluster_name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_ca_certificate" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}
