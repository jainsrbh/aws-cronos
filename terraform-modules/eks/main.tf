data "aws_region" "current" {}
data "aws_iam_roles" "roles" {
  name_regex = "AWSReservedSSO_AdministratorAccess_.*"
}

locals {
  eks_cluster_name                 = "${var.name_prefix}-cluster"
  kms_key_administrator_principals = data.aws_iam_roles.roles.arns
  eks_cluster_log_types            = distinct(concat(["authenticator", "audit"], var.eks_cluster_log_types))
}

module "kms" {
  source = "../kms"

  description = "KMS for EKS cluster ${var.name_prefix} and CloudWatch log group /aws/eks/${local.eks_cluster_name}/cluster"
  alias       = "${var.name_prefix}-eks"
  name        = "${var.name_prefix}-eks"
  kms_key_service_principals = [
    "eks.amazonaws.com",
    "logs.${data.aws_region.current.name}.amazonaws.com"
  ]

  kms_key_administrator_principals = length(var.kms_key_administrator_principals) > 0 ? var.kms_key_administrator_principals : local.kms_key_administrator_principals

  tags = var.tags
}

module "logs" {
  source            = "../cloudwatch_log_group"
  kms_key_id        = module.kms.key_arn
  name              = "/aws/eks/${local.eks_cluster_name}"
  retention_in_days = var.eks_cluster_logs_retention_period
  tags              = var.tags
}

resource "aws_eks_cluster" "this" {
  name                      = local.eks_cluster_name
  role_arn                  = module.iam_roles.iam_roles.eks.arn
  version                   = var.eks_version
  enabled_cluster_log_types = local.eks_cluster_log_types

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
    security_group_ids      = [var.eks_cluster_sg_id]
    subnet_ids              = var.subnet_ids
  }

  dynamic "kubernetes_network_config" {
    for_each = var.kubernetes_network_config == null ? [] : [var.kubernetes_network_config]

    content {
      service_ipv4_cidr = kubernetes_network_config.value.service_ipv4_cidr
    }
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = module.kms.key_arn
    }
  }

  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.eks_cluster_name}-nodes"
  node_role_arn   = module.iam_roles.iam_roles.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  ami_type       = var.eks_nodes_ami_type
  disk_size      = var.eks_nodes_disk_size
  instance_types = var.eks_nodes_instance_types
  capacity_type  = var.eks_nodes_capacity_type

  scaling_config {
    desired_size = var.eks_nodes_scaling_config.desired_size
    max_size     = var.eks_nodes_scaling_config.max_size
    min_size     = var.eks_nodes_scaling_config.min_size
  }

  update_config {
    max_unavailable_percentage = var.eks_nodes_max_unavailable_percentage
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }

  tags = merge(var.tags, {
    Name                                                 = "${local.eks_cluster_name}-nodes"
    "kubernetes.io/cluster/${aws_eks_cluster.this.name}" = "shared"
  })

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

resource "aws_eks_addon" "this" {
  for_each = var.eks_addons

  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = each.key
  addon_version               = each.value.addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = lookup(each.value, "service_account_role_arn", null)
}
