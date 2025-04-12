locals {
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
}

resource "aws_volume_attachment" "this" {
  for_each    = var.ebs_block_devices
  device_name = each.value.device_name
  volume_id   = each.value.ebs_id
  instance_id = aws_instance.this.id
}

resource "aws_network_interface" "main" {
  subnet_id               = var.subnet_id
  security_groups         = var.vpc_security_group_ids
  private_ip_list_enabled = true
  private_ip_list         = var.private_ip != null ? concat([var.private_ip], var.secondary_private_ips) : null
  description             = "${var.name}-main ENI"
  tags                    = merge(var.tags, { Name = "${var.name}-main" })
}

resource "aws_network_interface" "this" {
  for_each        = var.additional_network_interface
  subnet_id       = each.value.subnet_id
  security_groups = each.value.security_groups
  private_ips     = each.value.private_ips
  description     = "${var.name}-${each.key} ENI"
  tags            = merge(var.tags, { Name = "${var.name}-${each.key}" })
}

resource "aws_network_interface_attachment" "this" {
  for_each             = var.additional_network_interface
  instance_id          = aws_instance.this.id
  network_interface_id = aws_network_interface.this[each.key].id
  device_index         = each.value.device_index
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  cpu_core_count              = var.cpu_core_count
  cpu_threads_per_core        = var.cpu_threads_per_core
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change
  hibernation                 = var.hibernation

  availability_zone = var.availability_zone

  key_name             = var.key_name
  monitoring           = var.monitoring
  get_password_data    = var.get_password_data
  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = true
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = merge({ Name = "${var.name}-root" }, lookup(root_block_device.value, "tags", {}))
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    instance_metadata_tags      = "enabled"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.main.id
  }

  dynamic "enclave_options" {
    for_each = var.enclave_options != null ? [var.enclave_options] : []
    content {
      enabled = enclave_options.value.enabled
    }
  }

  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  tags = merge(var.tags, { Name = var.name })

  volume_tags = var.enable_volume_tags ? merge({ "Name" = var.name }, var.volume_tags) : null
}
