output "ecr_repository_arn" {
    value = aws_ecr_repository.ecsv2
  
}

output "github_repo" {
    value = "Blue-Green Deployment ECS"
  
}

output "dynamodb_table_arn" {
    value = aws_dynamodb_table.terraform_locks.arn
  
}

output "github_oidc_provider_arn" {
  
  value = aws_iam_openid_connect_provider.default.arn
}