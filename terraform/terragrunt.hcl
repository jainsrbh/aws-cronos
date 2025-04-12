# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  vertical     = local.account_vars.locals.common_tags.vertical
  project_name = local.account_vars.locals.common_tags.project
  org_name     = local.account_vars.locals.common_tags.org
  aws_region   = local.region_vars.locals.aws_region
  environment  = local.environment_vars.locals.environment_tags.environment
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  default_tags {
    tags = {
      # List of mandatory tags:
      # https://bctechnology.atlassian.net/wiki/spaces/SEC/pages/1969684561/BC+Group+AWS+Resources+mandatory+tags+and+values
      "OU"            = "${local.org_name}",
      "Environment"   = "${local.environment}",
      "Vertical"      = "${local.account_vars.locals.common_tags.vertical}",
      "Location"      = "${local.account_vars.locals.account_name}",
      "Region"        = "${local.region_vars.locals.region_alias}",
      "Project"       = "${local.project_name}",
      "tf_modules"    = "${try(local.environment_vars.locals.tf_modules_version, "")}",
      "service_template" = "${try(local.environment_vars.locals.service_template_version, "")}"
    }
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket = format("terraform-state-%s-%s-%s-%s",
      local.account_name,
      local.vertical,
      local.project_name,
      local.aws_region
    )
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
