include {
  path = find_in_parent_folders()
}

locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env            = local.environment_vars.locals.environment_tags.environment
  project_name   = local.account_vars.locals.common_tags.project
  aws_region     = local.region_vars.locals.aws_region
  aws_account_id = local.account_vars.locals.aws_account_id
}

terraform {
  source = "${get_repo_root()}/terraform-modules/security_groups"
}

dependency "network" {
  config_path  = "../network"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    vpc_id                     = "vpc-MOCK"
    vpc_cidr_block             = "10.25.0.0/16"
    private_subnet_cidr_blocks = ["10.25.1.0/22"]
    private_subnets = {
      "eks" = "10.25.10.0/22"
    }
  }
}

inputs = {
  name_prefix = local.env
  vpc_id      = dependency.network.outputs.vpc_id
  security_groups = {
    vpc-endpoints = {
      description = "VPC Endpoints Security Group for ${local.env}"
      ingress = {
        allow-https = {
          port        = 443
          cidr_blocks = [dependency.network.outputs.vpc_cidr_block]
          description = "Ingress to VPC endpoints from entire VPC CIDR"
        }
      }
    }
  }
}
