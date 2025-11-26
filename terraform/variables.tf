variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "depi-graduation"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "node_ami_type" {
  type    = string
  default = "AL2023_x86_64_STANDARD"
}

variable "desired_capacity" {
  type    = number
  default = 1
}
