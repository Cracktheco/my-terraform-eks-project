module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  manage_aws_auth = true

  tags = {
    Environment = var.environment
  }
}

output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "kubeconfig" {
  value = module.eks_cluster.kubeconfig
}
