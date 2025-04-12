# aws_eks_cluster endpoint
output "k8s_endpoint" {
  description = "Kubernetes API server Endpoint"
  value       = aws_eks_cluster.this.endpoint
}

# k8s certificate
output "k8s_cert" {
  description = "Kubernetes CA certificate"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "k8s_cluster_arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.this.name
}

output "eks_version" {
  description = "EKS Cluster/Kubernetes Version"
  value       = aws_eks_cluster.this.version
}

output "k8s_cluster_oidc_issuer" {
  description = "EKS Cluster OIDC Issuer URL"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "k8s_oidc_provider_arn" {
  description = "Deployed Kubernetes Version"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "k8s_cluster_log_group_arn" {
  description = "ARN of the CloudWatch log group for the EKS cluster"
  value       = module.logs.arn
}

output "k8s_cluster_log_group_name" {
  description = "Name of the CloudWatch log group for the EKS cluster"
  value       = module.logs.name
}

output "eks_node_group_role_arn" {
  description = "Role ARN for the node group"
  value       = aws_eks_node_group.this.node_role_arn
}

output "service_account_iam_roles" {
  description = "IAM Roles created by this module"
  value       = module.kubernetes_service_accounts_iam_roles.iam_roles
}
