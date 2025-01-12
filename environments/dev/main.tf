terraform {
  required_version = ">= 1.3.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.kubeconfig["cluster_ca_certificate"])
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

/*
  Call the modules:
  1. VPC
  2. EKS
  3. EC2 Worker
  4. ALB Ingress
*/
module "vpc" {
  source      = "../../modules/vpc"
  vpc_name    = "${var.environment}-vpc"
  environment = var.environment
}

module "eks_cluster" {
  source      = "../../modules/eks"
  cluster_name   = "${var.environment}-eks-cluster"
  cluster_version = "1.24"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  environment  = var.environment
}

module "ec2_worker" {
  source  = "../../modules/ec2-worker"
  ami_id  = var.ami_id
  worker_sg_id       = module.vpc.vpc.public_subnets[0] # Example usage – typically you'd create a worker security group
  private_subnet_id  = module.vpc.private_subnets[0]
  cluster_name       = module.eks_cluster.cluster_name
  cluster_endpoint   = module.eks_cluster.cluster_id
  cluster_certificate_authority = module.eks_cluster.kubeconfig["cluster_ca_certificate"]
  environment        = var.environment
}

module "alb_controller" {
  source                      = "../../modules/alb-ingress"
  cluster_name                = module.eks_cluster.cluster_name
  cluster_endpoint            = module.eks_cluster.cluster_id
  cluster_certificate_authority = module.eks_cluster.kubeconfig["cluster_ca_certificate"]
  vpc_id                      = module.vpc.vpc_id
}

# For your container (nginx) deployment, either add here or keep in separate .tf
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = "default"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = "default"
    labels = {
      app = "nginx"
    }
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
    }
  }
  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.nginx.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

