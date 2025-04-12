output "ebs_id" {
  description = "The volume ID (e.g., vol-59fcb34e)."
  value       = aws_ebs_volume.this[*].id
}

output "ebs_arn" {
  description = "The volume ARN (e.g., arn:aws:ec2:us-east-1:0123456789012:volume/vol-59fcb34e)."
  value       = aws_ebs_volume.this[*].arn
}

output "protected_ebs_id" {
  description = "The volume ID (e.g., vol-59fcb34e)."
  value       = aws_ebs_volume.protected[*].id
}

output "protected_ebs_arn" {
  description = "The volume ID (e.g., vol-59fcb34e)."
  value       = aws_ebs_volume.protected[*].arn
}