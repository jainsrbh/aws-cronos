resource "aws_ecr_repository" "this" {
  for_each = var.repositories

  name = "${var.name_prefix}${each.key}"

  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(var.tags, { "Name" = "${var.name_prefix}${each.key}" })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name

  policy = jsonencode({
    rules = flatten([
      {
        rulePriority = 1,
        description  = "Remove untagged images",
        selection = {
          tagStatus   = "untagged",
          countType   = "imageCountMoreThan",
          countNumber = 1,
        },
        action = {
          type = "expire",
        }
      },
      var.branch_images.days != 0 ? [{
        rulePriority = 3,
        description  = "Delete branch builds after ${var.branch_images.days} days",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = [var.branch_images.prefix],
          countType     = "sinceImagePushed",
          countUnit     = "days",
          countNumber   = var.branch_images.days
        },
        action = {
          type = "expire"
        }
      }] : []
    ])
  })
}

data "aws_iam_policy_document" "readonly_access" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principals_readonly_access
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
  }
}

data "aws_iam_policy_document" "full_access" {
  statement {
    sid    = "FullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principals_full_access
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
  }
}

data "aws_iam_policy_document" "lambda_access" {
  statement {
    sid    = "LambdaAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    condition {
      test     = "StringLike"
      variable = "aws:sourceArn"

      values = var.principals_lambda_access
    }
  }
}

locals {
  need_readonly_policy      = length(var.principals_readonly_access) > 0
  need_full_access_policy   = length(var.principals_full_access) > 0
  need_lambda_access_policy = length(var.principals_lambda_access) > 0
  need_policy               = anytrue([anytrue([local.need_readonly_policy, local.need_full_access_policy]), local.need_lambda_access_policy])
  override_polices = compact([
    local.need_full_access_policy ? data.aws_iam_policy_document.full_access.json : "",
    local.need_lambda_access_policy ? data.aws_iam_policy_document.lambda_access.json : ""
  ])
}

data "aws_iam_policy_document" "merge" {
  source_policy_documents   = compact([local.need_readonly_policy ? data.aws_iam_policy_document.readonly_access.json : ""])
  override_policy_documents = local.override_polices
}

resource "aws_ecr_repository_policy" "this" {
  for_each   = local.need_policy ? aws_ecr_repository.this : {}
  repository = each.value.name
  policy     = data.aws_iam_policy_document.merge.json
}
