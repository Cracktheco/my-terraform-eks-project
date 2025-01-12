provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

data "aws_eks_cluster_auth" "auth" {
  name = var.cluster_name
}

resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  
  values = [
    templatefile("${path.module}/values.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}
