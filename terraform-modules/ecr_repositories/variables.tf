variable "name_prefix" {
  type        = string
  description = "The name prefix for all parameters."
}

variable "repositories" {
  type        = map(object({}))
  description = "Map of the repositories."
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "Choose either `IMMUTABLE` or `MUTABLE` for image tags."
}

variable "principals_readonly_access" {
  type        = list(any)
  default     = []
  description = "Principal ARN to provide with readonly access to the ECR."
}

variable "principals_full_access" {
  type        = list(any)
  description = "Principal ARN to provide with full access to the ECR."
  default     = []
}

variable "principals_lambda_access" {
  type        = list(any)
  description = "List of ARNs which will pull images using Lambda"
  default     = []
}

variable "scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default     = true
}

variable "kms_key" {
  type        = string
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default     = null
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to the object."
}

variable "branch_images" {
  default = {
    days   = 0
    prefix = ""
  }
  type = object({
    days   = number
    prefix = string
  })
  description = "If set, it will delete images with `prefix` tag that are older than `days` days."

  validation {
    condition     = (var.branch_images.days == 0 && var.branch_images.prefix == "") || (var.branch_images.days != 0 && var.branch_images.prefix != "")
    error_message = "Error, you need to set both days and prefix."
  }

}
