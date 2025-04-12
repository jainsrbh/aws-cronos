# ec2 module

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
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/instance) | resource |
| [aws_network_interface.main](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/network_interface) | resource |
| [aws_network_interface.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/network_interface) | resource |
| [aws_network_interface_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/network_interface_attachment) | resource |
| [aws_volume_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_network_interface"></a> [additional\_network\_interface](#input\_additional\_network\_interface) | Customize network interfaces to be attached at instance boot time | <pre>map(object({<br>    device_index    = number<br>    subnet_id       = string<br>    private_ips     = optional(list(string))<br>    security_groups = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | ID of AMI to use for the instance | `string` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC | `bool` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ to start the instance in | `string` | n/a | yes |
| <a name="input_cpu_core_count"></a> [cpu\_core\_count](#input\_cpu\_core\_count) | Sets the number of CPU cores for an instance. | `number` | `null` | no |
| <a name="input_cpu_credits"></a> [cpu\_credits](#input\_cpu\_credits) | The credit option for CPU usage (unlimited or standard) | `string` | `null` | no |
| <a name="input_cpu_threads_per_core"></a> [cpu\_threads\_per\_core](#input\_cpu\_threads\_per\_core) | Sets the number of CPU threads per core for an instance (has no effect unless cpu\_core\_count is also set). | `number` | `null` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If true, enables EC2 Instance Termination Protection | `bool` | `null` | no |
| <a name="input_ebs_block_devices"></a> [ebs\_block\_devices](#input\_ebs\_block\_devices) | Additional EBS block devices to attach to the instance | <pre>map(object({<br>    device_name = string<br>    ebs_id      = string<br>  }))</pre> | `{}` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_enable_volume_tags"></a> [enable\_volume\_tags](#input\_enable\_volume\_tags) | Whether to enable volume tags (if enabled it conflicts with root\_block\_device tags) | `bool` | `true` | no |
| <a name="input_enclave_options"></a> [enclave\_options](#input\_enclave\_options) | Enable Nitro Enclaves on launched instances | `map(string)` | `null` | no |
| <a name="input_get_password_data"></a> [get\_password\_data](#input\_get\_password\_data) | If true, wait for password data to become available and retrieve it. | `bool` | `null` | no |
| <a name="input_hibernation"></a> [hibernation](#input\_hibernation) | If true, the launched EC2 instance will support hibernation | `bool` | `null` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile | `string` | `null` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start | `string` | `"t3.micro"` | no |
| <a name="input_ipv6_address_count"></a> [ipv6\_address\_count](#input\_ipv6\_address\_count) | A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet | `number` | `null` | no |
| <a name="input_ipv6_addresses"></a> [ipv6\_addresses](#input\_ipv6\_addresses) | Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource | `string` | `null` | no |
| <a name="input_metadata_http_put_response_hop_limit"></a> [metadata\_http\_put\_response\_hop\_limit](#input\_metadata\_http\_put\_response\_hop\_limit) | Desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. | `number` | `1` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, the launched EC2 instance will have detailed monitoring enabled | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on EC2 instance created | `string` | n/a | yes |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to associate with the instance in a VPC | `string` | `null` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Customize details about the root block device of the instance. See Block Devices below for details | `list(any)` | `[]` | no |
| <a name="input_secondary_private_ips"></a> [secondary\_private\_ips](#input\_secondary\_private\_ips) | A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block` | `list(string)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID to launch in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user\_data\_base64 instead. | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of user\_data to pass base64-encoded binary data directly. Use this instead of user\_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption. | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | When used in combination with `user_data` or `user_data_base64` will trigger a destroy and recreate when set to true. The default terraform behaviour will be to destroy before create, which will result in a downtime release. If you require zero downtime releases for ec2 instances, please consider autoscalling groups. Defaults to true if not set. | `string` | `true` | no |
| <a name="input_volume_tags"></a> [volume\_tags](#input\_volume\_tags) | A mapping of tags to assign to the devices created by the instance at launch time | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the instance. |
| <a name="output_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#output\_capacity\_reservation\_specification) | Capacity reservation specification of the instance |
| <a name="output_id"></a> [id](#output\_id) | The ID of the instance |
| <a name="output_instance_state"></a> [instance\_state](#output\_instance\_state) | The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped` |
| <a name="output_ipv6_addresses"></a> [ipv6\_addresses](#output\_ipv6\_addresses) | The IPv6 address assigned to the instance, if applicable. |
| <a name="output_outpost_arn"></a> [outpost\_arn](#output\_outpost\_arn) | The ARN of the Outpost the instance is assigned to |
| <a name="output_password_data"></a> [password\_data](#output\_password\_data) | Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows. This attribute is only exported if `get_password_data` is true |
| <a name="output_primary_network_interface_id"></a> [primary\_network\_interface\_id](#output\_primary\_network\_interface\_id) | The ID of the instance's primary network interface |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address assigned to the instance. |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws\_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
