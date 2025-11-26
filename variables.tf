variable "region" {
  default = "us-west-2"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]  
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]
}

variable "cluster_name" {
  default = "ci-cd-eks"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}



variable "node_group_instance_type" {
  default = "t3.medium"
}

variable "jenkins_ng_desired" {
  default = 1
}

variable "app_ng_desired" {
  default = 1
}
