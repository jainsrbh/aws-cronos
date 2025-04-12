include {
  path = find_in_parent_folders()
}

locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env            = local.environment_vars.locals.environment_tags.environment
  vertical       = local.account_vars.locals.common_tags.vertical
  aws_region     = local.region_vars.locals.aws_region
  aws_account_id = local.account_vars.locals.aws_account_id
}

terraform {
  source = "${get_repo_root()}/terraform-modules/security_groups"
}

dependency "network" {
  config_path  = "../../network"
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

dependency ec2_jump {
    config_path  = "../../ec2-jump-server/ec2"
    skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)

    mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
    mock_outputs = {
        private_ip = "10.15.0.5"
    }
}

inputs = {
  name_prefix = "${local.vertical}-${local.env}"
  vpc_id      = dependency.network.outputs.vpc_id
  security_groups = {
    web = {
      description = "Web server security groups"
      ingress = {
        allow-ssh = {
          port        = 22
          cidr_blocks = ["${dependency.ec2_jump.outputs.private_ip}/32"]
          description = "Permit ssh from jump server"
        }
      }
      egress = {
        allow-https-nat = {
          port        = 443
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow outgoing internet connections"
        }
      }
    }
  }
}
