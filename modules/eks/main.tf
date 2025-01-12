module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  tags = {
    Environment = var.environment
  }
}
