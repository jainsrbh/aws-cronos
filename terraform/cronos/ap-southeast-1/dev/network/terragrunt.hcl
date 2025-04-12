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
  source = "${get_repo_root()}/terraform-modules/network_v2"
}

inputs = {
  name_prefix    = local.env
  vpc_cidr_block = "10.15.0.0/16"
  nat_type       = "single"

  availability_zones = {
    "${local.aws_region}a" = {
      public_cidr = "10.15.0.0/24"
      private_cidrs = {
        vpce = "10.15.4.0/24"
        private  = "10.15.20.0/22"
      }
    }
    "${local.aws_region}b" = {
      public_cidr = "10.15.1.0/24"
      private_cidrs = {
        vpce = "10.15.5.0/24"
        private  = "10.15.24.0/22"
      }
    }
    "${local.aws_region}c" = {
      public_cidr = "10.15.2.0/24"
      private_cidrs = {
        vpce = "10.15.6.0/24"
        private  = "10.15.28.0/22"
      }
    }
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    private = {
      "kubernetes.io/role/internal-elb" = "1"
      "karpenter.sh/discovery"          = "${local.env}-private"
    }
  }
}
