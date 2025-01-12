output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks_cluster.cluster_id
}

output "kubeconfig" {
  description = "Kubeconfig for EKS cluster"
  value       = module.eks_cluster.kubeconfig
}
