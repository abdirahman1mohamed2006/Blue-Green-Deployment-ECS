

data "aws_route53_zone" "zone_ecs2" { 
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone_ecs2.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name  
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}