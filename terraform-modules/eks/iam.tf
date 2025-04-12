data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "eks_nodes_assume_role" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

module "iam_roles" {
  source      = "../iam_roles"
  name_prefix = var.name_prefix
  iam_roles = {
    eks = {
      instance_profile   = false
      assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
      policies           = {}
      policies_arn = {
        AmazonEKSClusterPolicy = {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        },
        AmazonEKSServicePolicy = {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
        }
      }
    }
    eks_nodes = {
      instance_profile   = true
      assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json
      policies           = {}
      policies_arn = {
        AmazonEKSWorkerNodePolicy = {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        },
        AmazonEKS_CNI_Policy = {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        }
        AmazonEC2ContainerRegistryReadOnly = {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        }
      }
    }
  }
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url            = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.this.certificates[0].sha1_fingerprint
  ]
}

module "kubernetes_service_accounts_iam_roles" {
  source = "../iam_roles"

  name_prefix = "${var.name_prefix}-eks"
  iam_roles = {
    for k, v in var.kubernetes_service_accounts : k => {
      assume_role_policy = templatefile("${path.module}/iam/k8s-service-account-assume-role-policy.json", {
        oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
        oidc_provider_url = aws_iam_openid_connect_provider.eks.url
        service_account   = "system:serviceaccount:${v.namespace}:${v.service_account_name != null ? v.service_account_name : k}"
        condition         = v.condition
      })
      policies     = v.policies
      policies_arn = v.policies_arn
    }
  }
}
