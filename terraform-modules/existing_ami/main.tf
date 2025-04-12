data "aws_ami" "this" {
  most_recent = var.most_recent
  name_regex  = var.name_regex
  owners      = var.owners

  filter {
    name   = "name"
    values = var.filter_name
  }

  dynamic "filter" {
    for_each = var.filter_root_device_type == null ? [] : [var.filter_root_device_type]

    content {
      name   = "root-device-type"
      values = var.filter_root_device_type
    }
  }

  dynamic "filter" {
    for_each = var.filter_virtualization_type == null ? [] : [var.filter_virtualization_type]

    content {
      name   = "virtualization-type"
      values = var.filter_virtualization_type
    }
  }
}
