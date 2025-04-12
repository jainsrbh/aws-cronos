terraform {

}

locals {
  availability_zones = sort(keys(var.availability_zones))
  single_nat_name    = sort(keys(var.availability_zones))[0]
  single_nat_zone    = { (local.single_nat_name) = lookup(var.availability_zones, local.single_nat_name, null) }
  nat_zones          = var.nat_type == "all" ? var.availability_zones : var.nat_type == "single" ? local.single_nat_zone : {}

  private_subnets_temp = { for zone, zone_info in var.availability_zones : zone => zone_info.private_cidrs }
  private_subnets_aggregated_list = flatten([for zone, zone_info in local.private_subnets_temp :
    [for private_name, private_cidr in zone_info :
      { key = "${private_name}-${zone}"
        value = {
          zone         = zone
          private_name = private_name
          private_cidr = private_cidr
        }
      }
  ]])
  private_subnets = { for k, v in local.private_subnets_aggregated_list : v.key => v.value }

  # Custom Private Subnets, with different route table rules
  custom_private_subnets_temp = { for zone, zone_info in var.availability_zones : zone => zone_info.custom_private_cidrs }
  custom_private_subnets_aggregated_list = flatten([for zone, zone_info in local.custom_private_subnets_temp :
    [for private_name, private_cidr in zone_info :
      { key = "${private_name}-${zone}"
        value = {
          zone         = zone
          private_name = private_name
          private_cidr = private_cidr
        }
      }
  ]])

  custom_private_subnets = { for k, v in local.custom_private_subnets_aggregated_list : v.key => v.value }

  # For Outputs only
  private_name_zone_map_temp        = { for k, v in local.private_subnets : v.private_name => { (v.zone) = k }... }
  private_name_zone_map             = { for k, v in local.private_name_zone_map_temp : k => zipmap(flatten([for item in v : keys(item)]), flatten([for item in v : values(item)])) }
  custom_private_name_zone_map_temp = { for k, v in local.custom_private_subnets : v.private_name => { (v.zone) = k }... }
  custom_private_name_zone_map      = { for k, v in local.custom_private_name_zone_map_temp : k => zipmap(flatten([for item in v : keys(item)]), flatten([for item in v : values(item)])) }
}

# AWS Virtual Private Network
resource "aws_vpc" "this" {
  #checkov:skip=CKV2_AWS_11: We may not always want vpc flow logs (test environments).
  #checkov:skip=CKV2_AWS_12: We have a default security group which blocks all traffic.
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-vpc" }
  )
}

# AWS Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = length([for az, az_values in var.availability_zones : az_values.public_cidr if az_values.public_cidr != null]) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-internet-gw" }
  )
}

# AWS Default Route Table
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-vpc" }
  )
}

# Create a route table for each public subnet
resource "aws_route_table" "public" {
  for_each = {
    for az, config in var.availability_zones :
    az => config
    if lookup(config, "public_cidr", null) != null
  }

  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-public-rt-${each.key}" }
  )
}

# Route internet bound traffic from public subnets via the internet gateway
resource "aws_route" "public_internet" {
  for_each = aws_route_table.public

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = one(aws_internet_gateway.this[*].id)
}

# AWS Subnets - Public
resource "aws_subnet" "public" {
  # checkov:skip=CKV_AWS_130: These are explicitly public subnets.
  for_each = {
    for az, config in var.availability_zones :
    az => config
    if lookup(config, "public_cidr", null) != null
  }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.public_cidr
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    var.public_subnet_tags,
    { Name = "${var.name_prefix}-public-net-${each.key}" }
  )
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.value.availability_zone].id
}

# Elastic IPs for NAT
resource "aws_eip" "this" {
  #checkov:skip=CKV2_AWS_19: This is conditional.
  for_each = local.nat_zones

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-nat-eip-${each.key}" }
  )
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  for_each      = local.nat_zones
  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-nat-gw-${each.key}" }
  )

  depends_on = [
    aws_internet_gateway.this
  ]
}

# AWS Subnets - Private
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.zone
  cidr_block              = each.value.private_cidr
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    lookup(var.private_subnet_tags, each.value.private_name, {}),
    { Name = "${var.name_prefix}-private-net-${each.key}" }
  )
}

# AWS Route Tables - Private
resource "aws_route_table" "private" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-private-rt-${each.key}" }
  )
}

# If we're deploying NAT gateways, add a route for it to the private route tables
resource "aws_route" "private_internet" {
  for_each = var.nat_type != null ? aws_route_table.private : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_type == "all" ? aws_nat_gateway.this[each.key].id : aws_nat_gateway.this[local.single_nat_name].id
}

# Associate the private subnets with their availability zone's route table
resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value.zone].id
}

# AWS Subnets - No Internet Private
resource "aws_subnet" "custom_private" {
  for_each = local.custom_private_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.zone
  cidr_block              = each.value.private_cidr
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    lookup(var.private_subnet_tags, each.value.private_name, {}),
    { Name = "${var.name_prefix}-custom-private-net-${each.key}" }
  )
}

# AWS Route Tables - No Internet Private
resource "aws_route_table" "custom_private" {
  for_each = var.availability_zones

  dynamic "route" {
    for_each = var.custom_private_routes

    content {
      cidr_block                = route.value.cidr_block
      carrier_gateway_id        = lookup(route.value, "carrier_gateway_id", null)
      core_network_arn          = lookup(route.value, "core_network_arn", null)
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      local_gateway_id          = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  vpc_id = aws_vpc.this.id
  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-custom-private-rt-${each.key}" }
  )
}

# Associate the private subnets with their availability zone's route table
resource "aws_route_table_association" "custom_private" {
  for_each = local.custom_private_subnets

  subnet_id      = aws_subnet.custom_private[each.key].id
  route_table_id = aws_route_table.custom_private[each.value.zone].id
}

# Default SG for VPC - Ensures the default SG restricts all traffic.
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-vpc-default-security-group" }
  )
}

# Ensure NACL are attached to subnets
resource "aws_network_acl" "private" {
  for_each   = aws_subnet.private
  vpc_id     = aws_vpc.this.id
  subnet_ids = [each.value.id]

  dynamic "ingress" {
    for_each = var.network_acl_private_ingress
    content {
      action     = lookup(ingress.value, "action", null)
      from_port  = lookup(ingress.value, "from_port", null)
      protocol   = lookup(ingress.value, "protocol", null)
      rule_no    = lookup(ingress.value, "rule_no", null)
      to_port    = lookup(ingress.value, "to_port", null)
      cidr_block = lookup(ingress.value, "cidr_block", null)
    }
  }

  dynamic "egress" {
    for_each = var.network_acl_private_egress
    content {
      action     = lookup(egress.value, "action", null)
      from_port  = lookup(egress.value, "from_port", null)
      protocol   = lookup(egress.value, "protocol", null)
      rule_no    = lookup(egress.value, "rule_no", null)
      to_port    = lookup(egress.value, "to_port", null)
      cidr_block = lookup(egress.value, "cidr_block", null)
    }
  }

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-private-nacl-${each.key}" }
  )
}

resource "aws_network_acl" "public" {
  for_each   = aws_subnet.public
  vpc_id     = aws_vpc.this.id
  subnet_ids = [each.value.id]

  dynamic "ingress" {
    for_each = var.network_acl_public_ingress
    content {
      action     = lookup(ingress.value, "action", null)
      from_port  = lookup(ingress.value, "from_port", null)
      protocol   = lookup(ingress.value, "protocol", null)
      rule_no    = lookup(ingress.value, "rule_no", null)
      to_port    = lookup(ingress.value, "to_port", null)
      cidr_block = lookup(ingress.value, "cidr_block", null)
    }
  }

  dynamic "egress" {
    for_each = var.network_acl_public_egress
    content {
      action     = lookup(egress.value, "action", null)
      from_port  = lookup(egress.value, "from_port", null)
      protocol   = lookup(egress.value, "protocol", null)
      rule_no    = lookup(egress.value, "rule_no", null)
      to_port    = lookup(egress.value, "to_port", null)
      cidr_block = lookup(egress.value, "cidr_block", null)
    }
  }

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-public-nacl-${each.key}" }
  )
}
