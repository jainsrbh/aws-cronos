# ECR repositories

Creates multiple ECR repositories for Docker images.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7, < 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.34.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.34.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy_document.full_access](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_access](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.merge](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.readonly_access](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_images"></a> [branch\_images](#input\_branch\_images) | If set, it will delete images with `prefix` tag that are older than `days` days. | <pre>object({<br>    days   = number<br>    prefix = string<br>  })</pre> | <pre>{<br>  "days": 0,<br>  "prefix": ""<br>}</pre> | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Choose either `IMMUTABLE` or `MUTABLE` for image tags. | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false). | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix for all parameters. | `string` | n/a | yes |
| <a name="input_principals_full_access"></a> [principals\_full\_access](#input\_principals\_full\_access) | Principal ARN to provide with full access to the ECR. | `list(any)` | `[]` | no |
| <a name="input_principals_lambda_access"></a> [principals\_lambda\_access](#input\_principals\_lambda\_access) | List of ARNs which will pull images using Lambda | `list(any)` | `[]` | no |
| <a name="input_principals_readonly_access"></a> [principals\_readonly\_access](#input\_principals\_readonly\_access) | Principal ARN to provide with readonly access to the ECR. | `list(any)` | `[]` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of the repositories. | `map(object({}))` | n/a | yes |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false). | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the object. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repositories"></a> [repositories](#output\_repositories) | The map of created repositories |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
