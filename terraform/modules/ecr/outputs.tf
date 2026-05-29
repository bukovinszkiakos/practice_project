output "repository_urls" {
  description = "Map of ECR repository URLs by repository suffix name."
  value = {
    for name, repo in aws_ecr_repository.this :
    name => repo.repository_url
  }
}

output "repository_arns" {
  description = "Map of ECR repository ARNs by repository suffix name."
  value = {
    for name, repo in aws_ecr_repository.this :
    name => repo.arn
  }
}

output "repository_names" {
  description = "Map of ECR repository names by repository suffix name."
  value = {
    for name, repo in aws_ecr_repository.this :
    name => repo.name
  }
}