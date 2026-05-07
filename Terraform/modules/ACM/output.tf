output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "validated_certificate_arn" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}