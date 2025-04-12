module "iam_roles" {
  source = "../"

  name_prefix = var.name_prefix
  iam_roles = {
    my-service = {
      assume_role_policy = <<ASSUME_ROLE_POLICY
      {
        "Version" : "2012-10-17",
        "Statement" : [{
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : { "Service" : ["ec2.amazonaws.com"] },
          "Action" : "sts:AssumeRole"
        }]
      }
      ASSUME_ROLE_POLICY
      policies_arn = merge(
        {
          AmazonSSMManagedInstanceCore = {
            policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
          }
        },
        true == true ? {
          AmazonECSTaskExecutionRolePolicy = {
            policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
          }
        } : null
      )
      policies = merge(
        {
          all_ec2 = <<POLICY_all_ec2
          {
            "Version" : "2012-10-17",
            "Statement" : [{
              "Effect" : "Allow",
              "Action" : ["ec2:*"],
              "Resource" : "*"
            }]
          }
          POLICY_all_ec2
        },
        true == true ? {
          all_ecs = <<POLICY_all_ecs
          {
            "Version" : "2012-10-17",
            "Statement" : [{
              "Effect" : "Allow",
              "Action" : ["ecs:*"],
              "Resource" : "*"
            }]
          }
          POLICY_all_ecs
        } : null
      )
    }
  }
  tags = var.tags
}
