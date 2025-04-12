#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  type        = string
  description = "Name prefix for resources on AWS"
}

variable "tags" {
  description = "Tags to use for resources that support them."
  type        = map(any)
  default     = {}
}

#------------------------------------------------------------------------------
# AWS Virtual Private Network
#------------------------------------------------------------------------------
variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR Block"
}

#------------------------------------------------------------------------------
# AWS Subnets
#------------------------------------------------------------------------------
variable "availability_zones" {
  type = map(
    object({
      public_cidr          = optional(string)
      private_cidrs        = map(string)
      custom_private_cidrs = optional(map(string), {})
    })
  )
  description = "The map of objects representing subnets CIDR information in AZ"
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to public subnets"
}

variable "private_subnet_tags" {
  type        = map(map(string))
  default     = {}
  description = "A map of private subnet names and tags"
}

variable "nat_type" {
  type        = string
  default     = null
  description = "Type of NAT Gateway can be 'single', 'all', and 'null' by default"
  validation {
    condition     = var.nat_type == null ? true : contains(["single", "all"], var.nat_type)
    error_message = "The nat_type must one of ['single', 'all', null]."
  }
}

# NACL Rules
variable "network_acl_private_ingress" {
  description = "Network ACL Private Ingress Rules"
  type = map(object({
    action     = string
    from_port  = number
    protocol   = string
    rule_no    = number
    to_port    = number
    cidr_block = string
  }))
  default = {
    default = {
      action     = "Allow"
      from_port  = 0
      protocol   = "-1"
      rule_no    = 100
      to_port    = 0
      cidr_block = "0.0.0.0/0"
    }
  }
}

variable "network_acl_private_egress" {
  description = "Network ACL Private Egress Rules"
  type = map(object({
    action     = string
    from_port  = number
    protocol   = string
    rule_no    = number
    to_port    = number
    cidr_block = string
  }))
  default = {
    default = {
      action     = "Allow"
      from_port  = 0
      protocol   = "-1"
      rule_no    = 100
      to_port    = 0
      cidr_block = "0.0.0.0/0"
    }
  }
}

variable "network_acl_public_ingress" {
  description = "Network ACL Public Ingress Rules"
  type = map(object({
    action     = string
    from_port  = number
    protocol   = string
    rule_no    = number
    to_port    = number
    cidr_block = string
  }))
  default = {
    default = {
      action     = "Allow"
      from_port  = 0
      protocol   = "-1"
      rule_no    = 100
      to_port    = 0
      cidr_block = "0.0.0.0/0"
    }
  }
}

variable "network_acl_public_egress" {
  description = "Network ACL Public Egress Rules"
  type = map(object({
    action     = string
    from_port  = number
    protocol   = string
    rule_no    = number
    to_port    = number
    cidr_block = string
  }))
  default = {
    default = {
      action     = "Allow"
      from_port  = 0
      protocol   = "-1"
      rule_no    = 100
      to_port    = 0
      cidr_block = "0.0.0.0/0"
    }
  }
}

variable "custom_private_routes" {
  description = "List of custom routes for our custom private subnets."
  type = list(object({
    cidr_block                = string
    carrier_gateway_id        = optional(string)
    core_network_arn          = optional(string)
    egress_only_gateway_id    = optional(string)
    gateway_id                = optional(string)
    local_gateway_id          = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
  }))
  default = []
}
