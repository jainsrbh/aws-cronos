locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  vertical     = local.env_vars.locals.vertical
  images       = yamldecode(file("images.yml"))
  aws_account_id = local.account_vars.locals.aws_account_id
  repositories = { for repo in distinct(local.images.ecr_repositories) : repo => {} }
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_repo_root()}/terraform-modules/ecr_repositories"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  name_prefix                = "${local.vertical}/"
  repositories               = local.repositories
  scan_on_push               = true
  image_tag_mutability       = "IMMUTABLE"
  principals_readonly_access =  ["arn:aws:iam::${local.aws_account_id}:root"]
}
