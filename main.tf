terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------
# VPC
# -----------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment
  }
}

# -----------------------------
# EKS Cluster
# -----------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  # -----------------------------
  # Control Plane Security Group Rules
  # -----------------------------
  cluster_security_group_additional_rules = {
    ingress_api_server = {
      description = "Allow worker nodes to talk to EKS API server"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr]
    }

    egress_all = {
      description = "Allow all outbound traffic"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # -----------------------------
  # Worker Node Groups (EC2)
  # -----------------------------
  eks_managed_node_groups = {
    default = {
      desired_size = 2
      min_size     = 1
      max_size     = 3

      instance_types = ["t3.medium"]

      # -----------------------------
      # Node Security Group Rules
      # -----------------------------
      security_group_additional_rules = {
        ingress_cluster = {
          description = "Allow cluster control plane to reach nodes"
          protocol    = "tcp"
          from_port   = 1025
          to_port     = 65535
          type        = "ingress"
          cidr_blocks = [var.vpc_cidr]
        }

        ingress_node_to_node = {
          description = "Allow node-to-node communication"
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          type        = "ingress"
          cidr_blocks = [var.vpc_cidr]
        }

        ingress_http = {
          description = "Allow HTTP traffic (Ingress / LoadBalancer)"
          protocol    = "tcp"
          from_port   = 80
          to_port     = 80
          type        = "ingress"
          cidr_blocks = ["0.0.0.0/0"]
        }

        ingress_https = {
          description = "Allow HTTPS traffic"
          protocol    = "tcp"
          from_port   = 443
          to_port     = 443
          type        = "ingress"
          cidr_blocks = ["0.0.0.0/0"]
        }

        egress_all = {
          description = "Allow all outbound traffic"
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          type        = "egress"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  tags = {
    Environment = var.environment
  }
}
