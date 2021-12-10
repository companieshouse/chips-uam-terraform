resource "aws_route53_record" "chips_uam_alb_internal" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = var.dns_prefix
  type    = "A"

  alias {
    name                   = module.chips_uam_internal_alb.this_lb_dns_name
    zone_id                = module.chips_uam_internal_alb.this_lb_zone_id
    evaluate_target_health = true
  }
}