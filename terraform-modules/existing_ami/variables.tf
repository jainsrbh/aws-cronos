variable "filter_name" {
  description = "A list of values to be used under filter -> name section."
  type        = list(string)
}

variable "filter_root_device_type" {
  description = "A list of values to be used under filter -> root-device-type section."
  type        = list(string)
  default     = null

  validation {
    condition     = var.filter_root_device_type == null || var.filter_root_device_type == ["ebs"] || var.filter_root_device_type == ["instance-store"]
    error_message = "The filter_root_device_type must be either null, ebs or instance-store."
  }
}

variable "filter_virtualization_type" {
  description = "A list of values to be used under filter -> virtualization-type section."
  type        = list(string)
  default     = null

  validation {
    condition     = var.filter_virtualization_type == null || var.filter_virtualization_type == ["paravirtual"] || var.filter_virtualization_type == ["hvm"]
    error_message = "The filter_root_device_type must be either null, paravirtual or hvm."
  }
}

variable "name_regex" {
  description = "A regex string to apply to the AMI list returned by AWS. This allows more advanced filtering not supported from the AWS API. This filtering is done locally on what AWS returns, and could have a performance impact if the result is large. It is recommended to combine this with other options to narrow down the list AWS returns."
  type        = string
  default     = null
}

variable "most_recent" {
  description = "map of regexps to search for in IAM roles"
  type        = bool
  default     = true
}

variable "owners" {
  description = "List of AMI owners to limit search. At least 1 value must be specified. Valid values: an AWS account ID, self (the current account), or an AWS owner alias (e.g., amazon, aws-marketplace, microsoft)"
  type        = list(string)
  default     = ["self"]
}
