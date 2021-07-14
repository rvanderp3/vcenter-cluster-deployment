provider "nsxt" {
  host                 = var.nsxt_proxy_host
  username            = var.username
  password            = var.password
  allow_unverified_ssl = true
  
}

module "segments" {
  source             = "./segments"
  count              = var.segment_count
  name               = "${var.segment_name}-${var.segment_start_number + count.index}"
  cidr               = "${var.segment_subnet}.${var.segment_start_number + count.index}.1/${var.segment_subnet_mask}"
  dhcp_ranges        = ["${var.segment_subnet}.${var.segment_start_number + count.index}.${var.segment_dhcp_start}-${var.segment_subnet}.${var.segment_start_number + count.index}.${var.segment_dhcp_end}"]
  domain_name        = var.segment_domain_name
  dns_servers        = var.segment_dns_servers
  dhcp_lease_timeout = var.segment_dhcp_lease_timeout
  dhcp_server        = "${var.segment_subnet}.${var.segment_start_number + count.index}.5/24"
}

module "groups" {
  source             = "./groups"
  count              = var.segment_count
  name               = "${var.segment_name}-${var.segment_start_number + count.index}"
  segment               = "${var.segment_name}-${var.segment_start_number + count.index}"
  depends_on = [module.segments]
}

module "serverpools" {
  source             = "./serverpools"
  count              = var.segment_count
  name               = "${var.segment_name}-${var.segment_start_number + count.index}"
  depends_on = [module.groups]
}

module "loadbalancers" {
  source             = "./loadbalancers"
  count              = var.segment_count
  name               = "${var.segment_name}-${var.segment_start_number + count.index}"
  api_ipaddress      = "${var.segment_load_balancer}.${var.segment_load_balancer_start + ((var.segment_start_number + count.index) * 2)}"
  ingress_ipaddress      = "${var.segment_load_balancer}.${var.segment_load_balancer_start + ((var.segment_start_number + count.index) * 2) + 1}"
  lb_path            = var.lb_path
  depends_on = [module.serverpools]
}

#resource "nsxt_policy_group" "test" {
 # (resource arguments)
#}