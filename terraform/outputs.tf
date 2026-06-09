output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.subnet.private_subnet_ids
}

output "eks_cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  description = "ECR repository URLs."
  value       = module.ecr.repository_urls
}

output "rds_endpoint" {
  description = "RDS endpoint address."
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "RDS port."
  value       = module.rds.db_port
}

output "rds_db_name" {
  description = "RDS database name."
  value       = module.rds.db_name
}

output "eks_oidc_issuer" {
  description = "EKS OIDC issuer"
  value       = module.eks.oidc_issuer
}

output "alb_controller_role_arn" {
  description = "ARN of the ALB Controller IAM role."
  value       = aws_iam_role.alb_controller.arn
}