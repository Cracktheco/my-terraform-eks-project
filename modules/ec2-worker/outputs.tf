output "ec2_worker_id" {
  description = "EC2 instance worker node ID"
  value       = aws_instance.eks_worker.id
}
