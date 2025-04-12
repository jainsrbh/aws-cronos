#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "availability_zones" {
  description = "List of availability zones used by subnets"
  value       = toset(local.availability_zones)
}

#------------------------------------------------------------------------------
# AWS Internet Gateway
#------------------------------------------------------------------------------
output "internet_gateway_id" {
  description = "ID of the generated Internet Gateway"
  value       = one(aws_internet_gateway.this[*].id)
}

#------------------------------------------------------------------------------
# AWS Subnets - Public
#------------------------------------------------------------------------------
output "public_subnets_ids" {
  description = "List with the Public Subnets IDs"
  value       = toset([for k, v in aws_subnet.public : v.id])
}

output "public_subnets_ids_full" {
  description = "Map with the Private Subnets IDs grouped by private subnete name and availability zones"
  value       = { for k, v in var.availability_zones : k => aws_subnet.public[k].id if v.public_cidr != null }
}

output "nat_gw_ids" {
  description = "List with the IDs of the NAT Gateways created on public subnets to provide internet to private subnets"
  value       = toset([for k, v in aws_nat_gateway.this : v.id])
}

#------------------------------------------------------------------------------
# AWS Subnets - Private
#------------------------------------------------------------------------------
output "private_subnets_ids" {
  description = "List with the Private Subnets IDs"
  value       = toset([for k, v in aws_subnet.private : v.id])
}

output "private_subnets_route_table_id" {
  description = "ID of the Route Table used on Private networks"
  value       = toset([for k, v in aws_route_table.private : v.id])
}

output "private_subnets" {
  description = "Map with the Private Subnets IDs grouped by private subnete name"
  value       = { for k, v in local.private_subnets : v.private_name => aws_subnet.private[k].id... }
}

output "private_subnets_full" {
  description = "Map with the Private Subnets IDs grouped by private subnete name and availability zones"
  value       = { for k, v in local.private_name_zone_map : k => { for k2, v2 in v : k2 => aws_subnet.private[v2].id } }
}

#------------------------------------------------------------------------------
# AWS Subnets - Custom Private
#------------------------------------------------------------------------------
output "custom_private_subnets_ids" {
  description = "List with the Private Subnets IDs"
  value       = toset([for k, v in aws_subnet.custom_private : v.id])
}

output "custom_private_subnets_route_table_id" {
  description = "ID of the Route Table used on Private networks"
  value       = toset([for k, v in aws_route_table.custom_private : v.id])
}

output "custom_private_subnets" {
  description = "Map with the Private Subnets IDs grouped by private subnete name"
  value       = { for k, v in local.custom_private_subnets : v.private_name => aws_subnet.custom_private[k].id... }
}

output "custom_private_subnets_full" {
  description = "Map with the Private Subnets IDs grouped by private subnete name and availability zones"
  value       = { for k, v in local.custom_private_name_zone_map : k => { for k2, v2 in v : k2 => aws_subnet.custom_private[v2].id } }
}

#------------------------------------------------------------------------------
# AWS Default Security Group
#------------------------------------------------------------------------------
output "default_security_group_id" {
  description = "Default Security Group ID for the VPC"
  value       = aws_default_security_group.this.id
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  value       = length(local.availability_zones) > 0 ? toset([for k, v in aws_subnet.public : v.cidr_block]) : null
}

output "public_subnet_cidr_blocks_full" {
  description = "Map with the Private Subnets IDs grouped by private subnete name and availability zones"
  value       = { for k, v in aws_subnet.public : v.availability_zone => v.cidr_block }
}

output "private_subnet_cidr_blocks" {
  description = "Subnet CIDR blocks for the private subnets"
  value       = length(local.availability_zones) > 0 ? toset([for k, v in aws_subnet.private : v.cidr_block]) : null
}

output "private_subnet_cidr_blocks_group" {
  description = "Map with the Private Subnets CIDR blocks grouped by private subnet name"
  value       = { for k, v in local.private_subnets : v.private_name => aws_subnet.private[k].cidr_block... }
}

output "custom_private_subnet_cidr_blocks_group" {
  description = "Map with the Custom Private Subnets CIDR blocks grouped by private subnet name"
  value       = { for k, v in local.custom_private_subnets : v.private_name => aws_subnet.custom_private[k].cidr_block... }
}

output "private_subnet_cidr_blocks_full" {
  description = "Map with the Private Subnets IDs grouped by private subnete name and availability zones"
  value       = { for k, v in local.private_name_zone_map : k => { for k2, v2 in v : k2 => aws_subnet.private[v2].cidr_block } }
}

output "private_route_table_id" {
  description = "Route Table IDs for private VPC"
  value       = aws_vpc.this.main_route_table_id
}
