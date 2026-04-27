output "alb_sg" {
    value = aws_security_group.alb_sg
  
}

output "blue_tg" {
    value = aws_lb_target_group.blue_tg
  
}

output "green_tg" {
    value = aws_lb_target_group.green_tg
  
}

output "alb_dns_name" {
  value = aws_lb.test.dns_name

}

output "alb_zone_id" {
  value = aws_lb.test.zone_id

}

output "listener_ecsv2" {
    value = aws_lb_listener.listener_ecsv2
  
}