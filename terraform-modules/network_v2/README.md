# Network Module

This Terraform module will provide:

- VPC
- Private Subnets (Can be multiple by AZ)
- Public Subnets
- Route Tables for private Subnets
- NAT GW (single, per AZ or disabled)
- Internet GW

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
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/default_security_group) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/network_acl) | resource |
| [aws_route.private_internet](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route) | resource |
| [aws_route.public_internet](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route) | resource |
| [aws_route_table.custom_private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route_table) | resource |
| [aws_route_table_association.custom_private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/route_table_association) | resource |
| [aws_subnet.custom_private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The map of objects representing subnets CIDR information in AZ | <pre>map(<br>    object({<br>      public_cidr          = optional(string)<br>      private_cidrs        = map(string)<br>      custom_private_cidrs = optional(map(string), {})<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_custom_private_routes"></a> [custom\_private\_routes](#input\_custom\_private\_routes) | List of custom routes for our custom private subnets. | <pre>list(object({<br>    cidr_block                = string<br>    carrier_gateway_id        = optional(string)<br>    core_network_arn          = optional(string)<br>    egress_only_gateway_id    = optional(string)<br>    gateway_id                = optional(string)<br>    local_gateway_id          = optional(string)<br>    nat_gateway_id            = optional(string)<br>    network_interface_id      = optional(string)<br>    transit_gateway_id        = optional(string)<br>    vpc_endpoint_id           = optional(string)<br>    vpc_peering_connection_id = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources on AWS | `string` | n/a | yes |
| <a name="input_nat_type"></a> [nat\_type](#input\_nat\_type) | Type of NAT Gateway can be 'single', 'all', and 'null' by default | `string` | `null` | no |
| <a name="input_network_acl_private_egress"></a> [network\_acl\_private\_egress](#input\_network\_acl\_private\_egress) | Network ACL Private Egress Rules | <pre>map(object({<br>    action     = string<br>    from_port  = number<br>    protocol   = string<br>    rule_no    = number<br>    to_port    = number<br>    cidr_block = string<br>  }))</pre> | <pre>{<br>  "default": {<br>    "action": "Allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_network_acl_private_ingress"></a> [network\_acl\_private\_ingress](#input\_network\_acl\_private\_ingress) | Network ACL Private Ingress Rules | <pre>map(object({<br>    action     = string<br>    from_port  = number<br>    protocol   = string<br>    rule_no    = number<br>    to_port    = number<br>    cidr_block = string<br>  }))</pre> | <pre>{<br>  "default": {<br>    "action": "Allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_network_acl_public_egress"></a> [network\_acl\_public\_egress](#input\_network\_acl\_public\_egress) | Network ACL Public Egress Rules | <pre>map(object({<br>    action     = string<br>    from_port  = number<br>    protocol   = string<br>    rule_no    = number<br>    to_port    = number<br>    cidr_block = string<br>  }))</pre> | <pre>{<br>  "default": {<br>    "action": "Allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_network_acl_public_ingress"></a> [network\_acl\_public\_ingress](#input\_network\_acl\_public\_ingress) | Network ACL Public Ingress Rules | <pre>map(object({<br>    action     = string<br>    from_port  = number<br>    protocol   = string<br>    rule_no    = number<br>    to_port    = number<br>    cidr_block = string<br>  }))</pre> | <pre>{<br>  "default": {<br>    "action": "Allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | A map of private subnet names and tags | `map(map(string))` | `{}` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Tags to apply to public subnets | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to use for resources that support them. | `map(any)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of availability zones used by subnets |
| <a name="output_custom_private_subnet_cidr_blocks_group"></a> [custom\_private\_subnet\_cidr\_blocks\_group](#output\_custom\_private\_subnet\_cidr\_blocks\_group) | Map with the Custom Private Subnets CIDR blocks grouped by private subnet name |
| <a name="output_custom_private_subnets"></a> [custom\_private\_subnets](#output\_custom\_private\_subnets) | Map with the Private Subnets IDs grouped by private subnete name |
| <a name="output_custom_private_subnets_full"></a> [custom\_private\_subnets\_full](#output\_custom\_private\_subnets\_full) | Map with the Private Subnets IDs grouped by private subnete name and availability zones |
| <a name="output_custom_private_subnets_ids"></a> [custom\_private\_subnets\_ids](#output\_custom\_private\_subnets\_ids) | List with the Private Subnets IDs |
| <a name="output_custom_private_subnets_route_table_id"></a> [custom\_private\_subnets\_route\_table\_id](#output\_custom\_private\_subnets\_route\_table\_id) | ID of the Route Table used on Private networks |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | Default Security Group ID for the VPC |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the generated Internet Gateway |
| <a name="output_nat_gw_ids"></a> [nat\_gw\_ids](#output\_nat\_gw\_ids) | List with the IDs of the NAT Gateways created on public subnets to provide internet to private subnets |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | Route Table IDs for private VPC |
| <a name="output_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#output\_private\_subnet\_cidr\_blocks) | Subnet CIDR blocks for the private subnets |
| <a name="output_private_subnet_cidr_blocks_full"></a> [private\_subnet\_cidr\_blocks\_full](#output\_private\_subnet\_cidr\_blocks\_full) | Map with the Private Subnets IDs grouped by private subnete name and availability zones |
| <a name="output_private_subnet_cidr_blocks_group"></a> [private\_subnet\_cidr\_blocks\_group](#output\_private\_subnet\_cidr\_blocks\_group) | Map with the Private Subnets CIDR blocks grouped by private subnet name |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Map with the Private Subnets IDs grouped by private subnete name |
| <a name="output_private_subnets_full"></a> [private\_subnets\_full](#output\_private\_subnets\_full) | Map with the Private Subnets IDs grouped by private subnete name and availability zones |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | List with the Private Subnets IDs |
| <a name="output_private_subnets_route_table_id"></a> [private\_subnets\_route\_table\_id](#output\_private\_subnets\_route\_table\_id) | ID of the Route Table used on Private networks |
| <a name="output_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#output\_public\_subnet\_cidr\_blocks) | CIDR blocks for the public subnets |
| <a name="output_public_subnet_cidr_blocks_full"></a> [public\_subnet\_cidr\_blocks\_full](#output\_public\_subnet\_cidr\_blocks\_full) | Map with the Private Subnets IDs grouped by private subnete name and availability zones |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | List with the Public Subnets IDs |
| <a name="output_public_subnets_ids_full"></a> [public\_subnets\_ids\_full](#output\_public\_subnets\_ids\_full) | Map with the Private Subnets IDs grouped by private subnete name and availability zones |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
