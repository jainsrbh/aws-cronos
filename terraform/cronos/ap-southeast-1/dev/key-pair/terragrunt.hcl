include {
  path = find_in_parent_folders()
}

locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env          = local.environment_vars.locals.environment_tags.environment
  project_name = local.account_vars.locals.common_tags.project
  aws_region   = local.region_vars.locals.aws_region
}

terraform {
  source = "${get_repo_root()}/terraform-modules/key-pair"
}

inputs = {
  name_prefix = local.env
  key_name    = "${local.project_name}-${local.env}"
  tags        = {
    Name = "${local.project_name}-${local.env}"
  }
  create_private_key = true
}