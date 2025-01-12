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
  description = "Cluster CA"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
