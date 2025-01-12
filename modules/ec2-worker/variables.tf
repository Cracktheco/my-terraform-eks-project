variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 worker node"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID in which to launch the worker node"
}

variable "worker_sg_id" {
  type        = string
  description = "Security group ID for the worker node"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS Cluster endpoint"
}

variable "cluster_certificate_authority" {
  type        = string
  description = "Base64 encoded certificate authority of EKS cluster"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
