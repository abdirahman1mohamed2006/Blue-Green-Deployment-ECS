
resource "aws_acm_certificate" "cert" { 
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "validation" { 
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.alb_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

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