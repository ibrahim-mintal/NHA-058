provider "aws" {
  region = var.region
}

# provider "kubernetes" {
#   config_path = "~/.kube/config"       # Adjust if needed
 
# }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}


terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"   # Latest AWS provider
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"  # Latest Kubernetes provider
    }
  }
}


