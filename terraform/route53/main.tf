provider "aws" {
}

module "recordsets" {
  source             = "./recordsets"
  count              = var.segment_count
  domain             = var.domain
  segment_number     = "${count.index + var.segment_start_number}"  
  hosted_zone        = var.hosted_zone
  api_ipaddress      = "${var.segment_load_balancer}.${var.segment_load_balancer_start + ((var.segment_start_number + count.index) * 2)}"
  ingress_ipaddress  = "${var.segment_load_balancer}.${var.segment_load_balancer_start + ((var.segment_start_number + count.index) * 2) + 1}"
  cluster_name       = var.cluster_name
}

