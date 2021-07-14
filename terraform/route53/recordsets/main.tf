resource "aws_route53_record" "api" {
  zone_id = var.hosted_zone
  name    = "api.${var.cluster_name}${var.segment_number}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [var.api_ipaddress]
}

resource "aws_route53_record" "api-int" {
  zone_id = var.hosted_zone
  name    = "api-int.${var.cluster_name}${var.segment_number}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [var.api_ipaddress]
}

resource "aws_route53_record" "ingress" {
  zone_id = var.hosted_zone
  name    = "*.apps.${var.cluster_name}${var.segment_number}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [var.ingress_ipaddress]
}