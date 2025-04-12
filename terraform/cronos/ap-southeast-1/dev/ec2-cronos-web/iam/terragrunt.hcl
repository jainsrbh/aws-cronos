include {
  path = find_in_parent_folders()
}

locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  region       = local.region_vars.locals.aws_region
  region_alias = local.region_vars.locals.region_alias
  env          = local.environment_vars.locals.environment_tags.environment
  project_name = local.account_vars.locals.common_tags.project
  aws_account_id = local.account_vars.locals.aws_account_id
}

terraform {
  source = "${get_repo_root()}/terraform-modules/iam_roles"
}

inputs = {
  name_prefix = "${local.project_name}-web"
  iam_roles = {
    default = {
      instance_profile   = true
      assume_role_policy = <<ASSUME_ROLE_POLICY
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
          }
        ]
      }
      ASSUME_ROLE_POLICY
      policies = {
        iam_role_policy = <<IAM_POLICY
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                    "ec2:DescribeInstances"
                ],
              "Resource": "*"
            }
          ]
        }
        IAM_POLICY
        ecr_access_policy = <<ECR_POLICY
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage"
              ],
              "Resource": "*"
            }
          ]
        }
        ECR_POLICY
      }
    }
  }
}
