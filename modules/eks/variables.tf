variable "cluster_name" {
  type        = string
  description = "Name for the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.31"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets to place the EKS cluster"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
