# EKS Cluster module

This module creates an EKS cluster spanning across multiple AWS Availability Zones, with AWS managed nodes.

By default, you can access the EKS API endpoint from anywhere(`0.0.0.0/0`).
You can restrict the access by passing the trusted public ip list to the variable `eks_public_access_cidrs`.

## Prerequisites

TBC

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7, < 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.34.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.34.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../iam_roles | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../kms | n/a |
| <a name="module_kubernetes_service_accounts_iam_roles"></a> [kubernetes\_service\_accounts\_iam\_roles](#module\_kubernetes\_service\_accounts\_iam\_roles) | ../iam_roles | n/a |
| <a name="module_logs"></a> [logs](#module\_logs) | ../cloudwatch_log_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy_document.eks_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_nodes_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_roles.roles](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/iam_roles) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.34.0/docs/data-sources/region) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_addons"></a> [eks\_addons](#input\_eks\_addons) | Map of objects for creation of efs access points | <pre>map(object({<br>    addon_version            = string<br>    service_account_role_arn = optional(string)<br>  }))</pre> | <pre>{<br>  "coredns": {<br>    "addon_version": "v1.8.4-eksbuild.1"<br>  },<br>  "kube-proxy": {<br>    "addon_version": "v1.21.2-eksbuild.2"<br>  },<br>  "vpc-cni": {<br>    "addon_version": "v1.10.2-eksbuild.1"<br>  }<br>}</pre> | no |
| <a name="input_eks_cluster_log_types"></a> [eks\_cluster\_log\_types](#input\_eks\_cluster\_log\_types) | Types of logs that needs to exported to Cloudwatch LogGroup | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_eks_cluster_logs_retention_period"></a> [eks\_cluster\_logs\_retention\_period](#input\_eks\_cluster\_logs\_retention\_period) | Retention period for the EKS Cluster CloudWatch LogGroup | `number` | `1` | no |
| <a name="input_eks_cluster_sg_id"></a> [eks\_cluster\_sg\_id](#input\_eks\_cluster\_sg\_id) | EKS Cluster Security Group ID | `string` | n/a | yes |
| <a name="input_eks_nodes_ami_type"></a> [eks\_nodes\_ami\_type](#input\_eks\_nodes\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. | `string` | `"AL2_x86_64"` | no |
| <a name="input_eks_nodes_capacity_type"></a> [eks\_nodes\_capacity\_type](#input\_eks\_nodes\_capacity\_type) | Type of capacity associated with the EKS Node Group. | `string` | `"SPOT"` | no |
| <a name="input_eks_nodes_disk_size"></a> [eks\_nodes\_disk\_size](#input\_eks\_nodes\_disk\_size) | Disk size in GiB for worker nodes. | `number` | `100` | no |
| <a name="input_eks_nodes_instance_types"></a> [eks\_nodes\_instance\_types](#input\_eks\_nodes\_instance\_types) | List of instance types associated with the EKS Node Group. | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_eks_nodes_max_unavailable_percentage"></a> [eks\_nodes\_max\_unavailable\_percentage](#input\_eks\_nodes\_max\_unavailable\_percentage) | Desired max percentage of unavailable worker nodes during node group update. | `number` | `30` | no |
| <a name="input_eks_nodes_scaling_config"></a> [eks\_nodes\_scaling\_config](#input\_eks\_nodes\_scaling\_config) | The EKS Nodes scaling configuration for managed nodes. | <pre>object({<br>    desired_size = number<br>    max_size     = number<br>    min_size     = number<br>  })</pre> | <pre>{<br>  "desired_size": 2,<br>  "max_size": 3,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_eks_public_access_cidrs"></a> [eks\_public\_access\_cidrs](#input\_eks\_public\_access\_cidrs) | List of CIDR blocks can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | EKS Cluster/Kubernetes Version | `string` | `"1.23"` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Allows Amazon EKS public API server endpoint | `bool` | `true` | no |
| <a name="input_kms_key_administrator_principals"></a> [kms\_key\_administrator\_principals](#input\_kms\_key\_administrator\_principals) | The KMS Key administrator principals. This should always be set unless testing. | `list(string)` | `[]` | no |
| <a name="input_kubernetes_network_config"></a> [kubernetes\_network\_config](#input\_kubernetes\_network\_config) | Kubernetes network config https://registry.terraform.io/providers/hashicorp%20%20/aws/3.75.0/docs/resources/eks_cluster#kubernetes_network_config | <pre>object({<br>    service_ipv4_cidr = optional(string)<br>  })</pre> | <pre>{<br>  "service_ipv4_cidr": "172.16.0.0/12"<br>}</pre> | no |
| <a name="input_kubernetes_service_accounts"></a> [kubernetes\_service\_accounts](#input\_kubernetes\_service\_accounts) | A map of Kubernetes service accounts to policies. The namespace represents the Kubernetes namespace the service account is in. If the service account requires wildcards, you can set 'condition' to 'StringLike' and set the IAM  role name with 'service\_account\_name' | <pre>map(object({<br>    namespace = string<br>    policies  = map(string)<br>    policies_arn = optional(map(object({<br>      policy_arn = string<br>    })))<br>    condition            = optional(string, "StringEquals")<br>    service_account_name = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources created by this module | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnets where the EKS Cluster will be hosted | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to attach to all resources in this module, do not use if using default\_tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | EKS Cluster Name |
| <a name="output_eks_node_group_role_arn"></a> [eks\_node\_group\_role\_arn](#output\_eks\_node\_group\_role\_arn) | Role ARN for the node group |
| <a name="output_eks_version"></a> [eks\_version](#output\_eks\_version) | EKS Cluster/Kubernetes Version |
| <a name="output_k8s_cert"></a> [k8s\_cert](#output\_k8s\_cert) | Kubernetes CA certificate |
| <a name="output_k8s_cluster_arn"></a> [k8s\_cluster\_arn](#output\_k8s\_cluster\_arn) | EKS Cluster ARN |
| <a name="output_k8s_cluster_log_group_arn"></a> [k8s\_cluster\_log\_group\_arn](#output\_k8s\_cluster\_log\_group\_arn) | ARN of the CloudWatch log group for the EKS cluster |
| <a name="output_k8s_cluster_log_group_name"></a> [k8s\_cluster\_log\_group\_name](#output\_k8s\_cluster\_log\_group\_name) | Name of the CloudWatch log group for the EKS cluster |
| <a name="output_k8s_cluster_oidc_issuer"></a> [k8s\_cluster\_oidc\_issuer](#output\_k8s\_cluster\_oidc\_issuer) | EKS Cluster OIDC Issuer URL |
| <a name="output_k8s_endpoint"></a> [k8s\_endpoint](#output\_k8s\_endpoint) | Kubernetes API server Endpoint |
| <a name="output_k8s_oidc_provider_arn"></a> [k8s\_oidc\_provider\_arn](#output\_k8s\_oidc\_provider\_arn) | Deployed Kubernetes Version |
| <a name="output_service_account_iam_roles"></a> [service\_account\_iam\_roles](#output\_service\_account\_iam\_roles) | IAM Roles created by this module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
