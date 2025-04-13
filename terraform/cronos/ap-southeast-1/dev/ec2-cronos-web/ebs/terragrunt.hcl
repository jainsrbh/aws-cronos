locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region            = local.region_vars.locals.aws_region
  project_name = local.account_vars.locals.common_tags.project
  availability_zone = "${local.region}a"
}

terraform {
  source = "${get_repo_root()}/terraform-modules/ebs"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name              = "nginx-data"
  availability_zone = "${local.region}a"
  prevent_destroy   = true
  size              = 10
}

