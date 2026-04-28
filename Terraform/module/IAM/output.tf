output "codedeploy_role_arn" {
  description = "ARN of the IAM role used by CodeDeploy deployment group"
  value       = aws_iam_role.codedeploy_role.arn
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

