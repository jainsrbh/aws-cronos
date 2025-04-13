include {
  path = find_in_parent_folders()
}

locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env               = local.environment_vars.locals.environment_tags.environment
  project_name      = local.account_vars.locals.common_tags.project
  aws_account_id    = local.account_vars.locals.aws_account_id
  region            = local.region_vars.locals.aws_region
  vertical          = local.account_vars.locals.common_tags.vertical
  ec2_configuration = local.environment_vars.locals.ec2.web
  availability_zone = "${local.region}a"
  user_data_file    = "./userdata.tpl"
}

terraform {
  source = "${get_repo_root()}/terraform-modules/ec2"
}

dependency "network" {
  config_path  = "../../network"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    vpc_cidr_block = "10.0.0.0/16"
    private_subnets_full = {
      "private" = {
        (local.availability_zone) = "subnet-00000000000000000"
      }
    }
  }
}

dependency "key" {
  config_path  = "../../key-pair-jump"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    key_pair_name = "mock-key-pair"
  }
}

dependency "ami" {
  config_path  = "../ami"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    ami_id = "ami-mock1234567890"
  }
}

dependency "security_groups" {
  config_path  = "../security-groups"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    security_groups = { amq-ec2 = { id = "sg-mock" } }
  }
}

dependency "iam" {
  config_path  = "../iam"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    iam_roles = {
      default = {
        arn  = "mock-role-arn"
        name = "mock-role-name"
      }
    }
  }
}

dependency "ebs" {
  config_path  = "../ebs"
  skip_outputs = lookup(local.environment_vars.locals, "skip_outputs", false)
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "state", "destroy", "show"]
  mock_outputs = {
    ebs_id = "mock-id"
  }
}

inputs = {
  name                 = "${local.vertical}-${local.env}-web"
  ami                  = dependency.ami.outputs.ami_id
  availability_zone    = local.availability_zone
  subnet_id            = dependency.network.outputs.private_subnets_full.private["${local.availability_zone}"]
  iam_instance_profile = dependency.iam.outputs.iam_roles.default.name
  instance_type        = local.ec2_configuration.type
  key_name             = dependency.key.outputs.key_pair_name
  vpc_security_group_ids = [
    dependency.security_groups.outputs.security_groups.web.id
  ]
  user_data = templatefile(local.user_data_file, merge({
    aws_account_id  = local.aws_account_id
    region          = local.region
    image_tag       = "v6.0"
  }))
  metadata_http_tokens = "optional"
  ebs_block_devices = {
    "data" = {
      "device_name" = "/dev/sdh"
      "ebs_id"      = dependency.ebs.outputs.protected_ebs_id[0]
    }
  }
  tags = {
    Environment = "${local.env}"
    Vertical    = "${local.vertical}"
    Project     = "${local.project_name}"
  }
}
