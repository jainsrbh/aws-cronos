# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "mainnet"
  aws_account_id = "014498633927"
  aws_profile    = "cronos"
  common_tags = {
    # Vertical Short Name: https://bctechnology.atlassian.net/wiki/spaces/SEC/pages/1969684561/BC+Group+AWS+Resources+mandatory+tags+and+values#1.3.-Vertical
    vertical = "cronos"
    project  = "aws-cronos" # Your Project Name
    org      = "jainsrbh"
  }
}
