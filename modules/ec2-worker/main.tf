resource "aws_iam_role" "eks_worker_role" {
  name               = "${var.environment}-eks-worker-role"
  assume_role_policy = data.aws_iam_policy_document.eks_worker_assume_role_policy.json
  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "eks_worker_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach EKS worker node policies
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_instance_profile" "eks_worker_instance_profile" {
  name = "${var.environment}-eks-worker-instance-profile"
  role = aws_iam_role.eks_worker_role.name
}

resource "aws_instance" "eks_worker" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.worker_sg_id]
  iam_instance_profile        = aws_iam_instance_profile.eks_worker_instance_profile.name

  # Simplistic user data to join EKS cluster
  user_data = templatefile("${path.module}/user_data.sh", {
    cluster_name = var.cluster_name
    endpoint     = var.cluster_endpoint
    cert_auth    = var.cluster_certificate_authority
  })

  tags = {
    Environment = var.environment
  }
}

# We assume we have a file user_data.sh in this module directory
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    cluster_name = var.cluster_name
    endpoint     = var.cluster_endpoint
    cert_auth    = var.cluster_certificate_authority
  }
}

output "ec2_worker_id" {
  value = aws_instance.eks_worker.id
}
