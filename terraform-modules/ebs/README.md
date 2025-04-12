# EBS Module for Terraform

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
| [aws_ebs_volume.protected](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/ebs_volume) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The AZ where the EBS volume will exist. | `string` | n/a | yes |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | If true, the disk will be encrypted. | `bool` | `true` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The amount of IOPS to provision for the disk. Only valid for type of io1, io2 or gp3. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. When specifying kms\_key\_id, encrypted needs to be set to true. | `string` | `null` | no |
| <a name="input_multi_attach_enabled"></a> [multi\_attach\_enabled](#input\_multi\_attach\_enabled) | Specifies whether to enable Amazon EBS Multi-Attach. Multi-Attach is supported exclusively on io1 volumes. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The EBS volume name | `string` | n/a | yes |
| <a name="input_prevent_destroy"></a> [prevent\_destroy](#input\_prevent\_destroy) | Flag to prevent EBS from accidental deletion via respective lifecycle. | `bool` | `false` | no |
| <a name="input_size"></a> [size](#input\_size) | The size of the drive in GiBs | `number` | n/a | yes |
| <a name="input_snapshot_id"></a> [snapshot\_id](#input\_snapshot\_id) | A snapshot to base the EBS volume off of. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for EBS. | `map(string)` | `{}` | no |
| <a name="input_throughput"></a> [throughput](#input\_throughput) | The throughput that the volume supports, in MiB/s. Only valid for type of gp3. | `number` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp3). | `string` | `"gp3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_arn"></a> [ebs\_arn](#output\_ebs\_arn) | The volume ARN (e.g., arn:aws:ec2:us-east-1:0123456789012:volume/vol-59fcb34e). |
| <a name="output_ebs_id"></a> [ebs\_id](#output\_ebs\_id) | The volume ID (e.g., vol-59fcb34e). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
