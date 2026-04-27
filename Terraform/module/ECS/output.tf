output "cluster" {
    value = aws_ecs_cluster.ecs_cluster
  
}

output "ecs_sg" {
    value = aws_security_group.ecs_sg
  
}

output "ecs_logs" {
    value = aws_cloudwatch_log_group.ecs_logs
  
}

