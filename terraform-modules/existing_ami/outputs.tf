output "ami_arn" {
  description = "Arn of the AMI"
  value       = data.aws_ami.this.arn
}

output "ami_creation_date" {
  description = "Creation Date of the AMI"
  value       = data.aws_ami.this.creation_date
}

output "ami_block_device_mappings" {
  description = "Set of objects with block device mappings of the AMI"
  value       = data.aws_ami.this.block_device_mappings
}

output "ami_description" {
  description = "Description of the AMI"
  value       = data.aws_ami.this.description
}

output "ami_id" {
  description = "ID of the AMI"
  value       = data.aws_ami.this.id
}

output "ami_name" {
  description = "Name of AMI"
  value       = data.aws_ami.this.name
}

output "ami_owner_id" {
  description = "AWS Account ID who owns the AMI, equivalent to search Private AMI"
  value       = data.aws_ami.this.owner_id
}
