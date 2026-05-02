output "alb_sg" {
    value = aws_security_group.alb_sg.id
  
}

output "blue_tg_name" {
    value = aws_lb_target_group.blue_tg.name
  
}

output "green_tg_name" {
    value = aws_lb_target_group.green_tg.name
  
}

output "alb_dns_name" {
  value = aws_lb.ecsv2_lb.dns_name

}

output "alb_zone_id" {
  value = aws_lb.ecsv2_lb.zone_id

}

output "listener_ecsv2" {
    value = aws_lb_listener.listener_ecsv2.arn
  
}

output "ecsv2_lb" {
    value = aws_lb.ecsv2_lb
    
}