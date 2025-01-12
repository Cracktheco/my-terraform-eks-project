output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_id
}

output "public_subnets" {
  description = "List of public subnets"
  value       = module.public_subnets
}

output "private_subnets" {
  description = "List of private subnets"
  value       = module.private_subnets
}
