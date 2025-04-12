resource "aws_ebs_volume" "this" {
  #checkov:skip=CKV2_AWS_9:We don't need a backup plan for all ebs volumes
  count                = var.prevent_destroy ? 0 : 1
  availability_zone    = var.availability_zone
  size                 = var.size
  encrypted            = var.encrypted
  kms_key_id           = var.kms_key_id
  type                 = var.type
  multi_attach_enabled = var.multi_attach_enabled
  iops                 = var.iops
  throughput           = var.throughput
  snapshot_id          = var.snapshot_id
  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

moved {
  from = aws_ebs_volume.this
  to   = aws_ebs_volume.this[0]
}

resource "aws_ebs_volume" "protected" {
  #checkov:skip=CKV2_AWS_9:We don't need a backup plan for all ebs volumes
  count                = var.prevent_destroy ? 1 : 0
  availability_zone    = var.availability_zone
  size                 = var.size
  encrypted            = var.encrypted
  kms_key_id           = var.kms_key_id
  type                 = var.type
  multi_attach_enabled = var.multi_attach_enabled
  iops                 = var.iops
  throughput           = var.throughput
  snapshot_id          = var.snapshot_id
  tags = merge(
    var.tags,
    { Name = var.name }
  )
  lifecycle {
    prevent_destroy = true
  }
}
