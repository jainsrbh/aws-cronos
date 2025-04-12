locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project_name = local.account_vars.locals.common_tags.project
  ami = local.environment_vars.locals.ami_amazon_linux
}

terraform {
  source = "${get_repo_root()}/terraform-modules/existing_ami"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  most_recent = true
  filter_name = ["${local.ami.name}"]
  owners      = ["${local.ami.owner}"]
}

