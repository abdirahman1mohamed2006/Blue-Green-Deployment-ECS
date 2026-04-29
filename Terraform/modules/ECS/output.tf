output "cluster" {
    value = aws_ecs_cluster.ecs_cluster.name
  
}

output "ecs_sg" {
    value = aws_security_group.ecs_sg.id
  
}

output "ecs_logs" {
    value = aws_cloudwatch_log_group.ecs_logs
  
}

output "task_definition_arn" {
    value = aws_ecs_task_definition.task
  
}

output "service_name" {
    value = aws_ecs_service.bluegreen_service
  
}

