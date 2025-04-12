variable "name_prefix" {
  type        = string
  description = "Name prefix for resources created by this module"
}

variable "eks_cluster_sg_id" {
  description = "EKS Cluster Security Group ID"
  type        = string
}

variable "eks_version" {
  description = "EKS Cluster/Kubernetes Version"
  type        = string
  default     = "1.23"
}

variable "subnet_ids" {
  description = "List of subnets where the EKS Cluster will be hosted"
  type        = list(string)
}

variable "eks_cluster_logs_retention_period" {
  description = "Retention period for the EKS Cluster CloudWatch LogGroup"
  type        = number
  default     = 1
}

variable "eks_cluster_log_types" {
  description = "Types of logs that needs to exported to Cloudwatch LogGroup"
  type        = list(string)
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "kubernetes_network_config" {
  description = "Kubernetes network config https://registry.terraform.io/providers/hashicorp%20%20/aws/3.75.0/docs/resources/eks_cluster#kubernetes_network_config"
  type = object({
    service_ipv4_cidr = optional(string)
  })
  default = {
    service_ipv4_cidr = "172.16.0.0/12"
  }
}

variable "eks_public_access_cidrs" {
  description = "List of CIDR blocks can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "endpoint_public_access" {
  description = "Allows Amazon EKS public API server endpoint"
  type        = bool
  default     = true
}

variable "kms_key_administrator_principals" {
  description = "The KMS Key administrator principals. This should always be set unless testing."
  type        = list(string)
  default     = []
}

## Managed Nodes
variable "eks_nodes_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group."
  type        = string
  default     = "AL2_x86_64"

  validation {
    condition = contains([
      "AL2_x86_64",
      "AL2_x86_64_GPU",
      "AL2_ARM_64",
      "CUSTOM",
      "BOTTLEROCKET_ARM_64",
      "BOTTLEROCKET_x86_64",
    ], var.eks_nodes_ami_type)
    error_message = "The AMI Type must match a valid type see: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType."
  }
}

variable "eks_nodes_disk_size" {
  description = "Disk size in GiB for worker nodes."
  type        = number
  default     = 100
}

variable "eks_nodes_instance_types" {
  description = "List of instance types associated with the EKS Node Group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_nodes_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.eks_nodes_capacity_type)
    error_message = "The EKS Nodes Capactiy Type is using an invalid type. Valid values: ON_DEMAND, SPOT."
  }
}

variable "eks_nodes_scaling_config" {
  description = "The EKS Nodes scaling configuration for managed nodes."
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
  default = {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

variable "eks_addons" {
  type = map(object({
    addon_version            = string
    service_account_role_arn = optional(string)
  }))
  description = "Map of objects for creation of efs access points"
  default = {
    coredns = {
      addon_version = "v1.8.4-eksbuild.1"
    },
    vpc-cni = {
      addon_version = "v1.10.2-eksbuild.1"
    }
    kube-proxy = {
      addon_version = "v1.21.2-eksbuild.2"
    }
  }
}

variable "eks_nodes_max_unavailable_percentage" {
  description = "Desired max percentage of unavailable worker nodes during node group update."
  type        = number
  default     = 30
}

variable "tags" {
  description = "A map of tags to attach to all resources in this module, do not use if using default_tags."
  type        = map(string)
  default     = {}
}

variable "kubernetes_service_accounts" {
  description = "A map of Kubernetes service accounts to policies. The namespace represents the Kubernetes namespace the service account is in. If the service account requires wildcards, you can set 'condition' to 'StringLike' and set the IAM  role name with 'service_account_name'"
  type = map(object({
    namespace = string
    policies  = map(string)
    policies_arn = optional(map(object({
      policy_arn = string
    })))
    condition            = optional(string, "StringEquals")
    service_account_name = optional(string)
  }))
  default = {}
}
