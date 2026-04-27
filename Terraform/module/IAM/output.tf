output "codedeploy_role_arn" {
  description = "ARN of the IAM role used by CodeDeploy deployment group"
  value       = aws_iam_role.codedeploy_role.arn
}