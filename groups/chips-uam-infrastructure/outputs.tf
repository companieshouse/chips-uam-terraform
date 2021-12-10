output "chips_uam_frontend_address_internal" {
  value = aws_route53_record.chips_uam_alb_internal.fqdn
}