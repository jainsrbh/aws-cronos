variable "name" {
  type        = string
  description = "The EBS volume name"
}

variable "availability_zone" {
  type        = string
  description = "The AZ where the EBS volume will exist."
}

variable "size" {
  type        = number
  description = "The size of the drive in GiBs"
}

variable "encrypted" {
  type        = bool
  default     = true
  description = "If true, the disk will be encrypted."
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
}

variable "type" {
  type        = string
  default     = "gp3"
  description = "The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp3)."
}

variable "multi_attach_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable Amazon EBS Multi-Attach. Multi-Attach is supported exclusively on io1 volumes."
}

variable "iops" {
  type        = string
  default     = null
  description = "The amount of IOPS to provision for the disk. Only valid for type of io1, io2 or gp3."
}

variable "throughput" {
  type        = number
  default     = null
  description = "The throughput that the volume supports, in MiB/s. Only valid for type of gp3."

}

variable "snapshot_id" {
  type        = string
  default     = null
  description = "A snapshot to base the EBS volume off of."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for EBS."
}

variable "prevent_destroy" {
  type        = bool
  default     = false
  description = "Flag to prevent EBS from accidental deletion via respective lifecycle."
}
