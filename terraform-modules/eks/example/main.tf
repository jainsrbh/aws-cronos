module "example" {
  source = "../"

  eks_cluster_sg_id = "sg-0000000000"
  name_prefix       = "example"
  subnet_ids        = ["subnet-0000", "subnet-0000", "subnet-0000"]
}

module "example_iam" {
  source = "../"

  eks_cluster_sg_id = "sg-0000000000"
  name_prefix       = "iam"
  subnet_ids        = ["subnet-0000", "subnet-0000", "subnet-0000"]

  kubernetes_service_accounts = {
    cert-manager = {
      namespace = "ingress"
      policies = {
        cert-manager = templatefile("policy_cert_manager.json", {})
      }
    }

    account_with_wildcards = {
      namespace = "*"
      policies = {
        ebs-csi-controller = templatefile("policy_cert_manager.json", {})
      }
      condition            = "StringLike"
      service_account_name = "wildcard-*"
    }
  }
}
