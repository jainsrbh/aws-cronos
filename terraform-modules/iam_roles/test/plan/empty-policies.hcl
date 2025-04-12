name_prefix = "test"
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
  }
}
