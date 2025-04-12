# Existing AMI

This module will lookup existing AMI Id and return a single AMI information.

If there is more than a single match is returned by the search, Terraform will fail.
Ensure that your search is specific enough to return a single AMI ID only,
or use `var.most_recent` equals `true` to choose the most recent one

This module focus on use on the following filter to do the search:

* name => Compulsory
* root-device-type => Optional
* virtualization-type => Optional

We noticed some public AMIs doesn't have any AMI Name value hence it cannot be search on this module

In addition if a AMI Name using contains special character such as `()/.?# or space` declared under `var.filter_name`
The search might potential fail as the AWS API limitation. Some recomendation
* terraform recommends to use `var.name_regex` and/or
* Use the `*` in between where is a special character

In summary terraform will rely on the `aws ec2 describe-images` API
* https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html

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
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | A list of values to be used under filter -> name section. | `list(string)` | n/a | yes |
| <a name="input_filter_root_device_type"></a> [filter\_root\_device\_type](#input\_filter\_root\_device\_type) | A list of values to be used under filter -> root-device-type section. | `list(string)` | `null` | no |
| <a name="input_filter_virtualization_type"></a> [filter\_virtualization\_type](#input\_filter\_virtualization\_type) | A list of values to be used under filter -> virtualization-type section. | `list(string)` | `null` | no |
| <a name="input_most_recent"></a> [most\_recent](#input\_most\_recent) | map of regexps to search for in IAM roles | `bool` | `true` | no |
| <a name="input_name_regex"></a> [name\_regex](#input\_name\_regex) | A regex string to apply to the AMI list returned by AWS. This allows more advanced filtering not supported from the AWS API. This filtering is done locally on what AWS returns, and could have a performance impact if the result is large. It is recommended to combine this with other options to narrow down the list AWS returns. | `string` | `null` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | List of AMI owners to limit search. At least 1 value must be specified. Valid values: an AWS account ID, self (the current account), or an AWS owner alias (e.g., amazon, aws-marketplace, microsoft) | `list(string)` | <pre>[<br>  "self"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_arn"></a> [ami\_arn](#output\_ami\_arn) | Arn of the AMI |
| <a name="output_ami_block_device_mappings"></a> [ami\_block\_device\_mappings](#output\_ami\_block\_device\_mappings) | Set of objects with block device mappings of the AMI |
| <a name="output_ami_creation_date"></a> [ami\_creation\_date](#output\_ami\_creation\_date) | Creation Date of the AMI |
| <a name="output_ami_description"></a> [ami\_description](#output\_ami\_description) | Description of the AMI |
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | ID of the AMI |
| <a name="output_ami_name"></a> [ami\_name](#output\_ami\_name) | Name of AMI |
| <a name="output_ami_owner_id"></a> [ami\_owner\_id](#output\_ami\_owner\_id) | AWS Account ID who owns the AMI, equivalent to search Private AMI |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
