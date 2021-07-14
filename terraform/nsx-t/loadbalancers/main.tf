resource "nsxt_policy_lb_virtual_server" "api-loadbalancer" {
  display_name         = "${var.name}-api"
  nsx_id              = "${var.name}-api"
  enabled              = true
  application_profile_path   = "/infra/lb-app-profiles/default-tcp-lb-app-profile"
  ip_address           = "${var.api_ipaddress}"
  ports                = ["6443", "22623"]
  service_path         = var.lb_path
  max_concurrent_connections = 200
  max_new_connection_rate    = 200
  pool_path                  = "/infra/lb-pools/${var.name}-api"
}

resource "nsxt_policy_lb_virtual_server" "ingress-loadbalancer" {
  display_name         = "${var.name}-ingress"
  nsx_id              = "${var.name}-ingress"
  enabled              = true
  application_profile_path   = "/infra/lb-app-profiles/default-tcp-lb-app-profile"
  ip_address           = "${var.ingress_ipaddress}"
  ports                = ["443", "80"]
  service_path         = var.lb_path
  max_concurrent_connections = 200
  max_new_connection_rate    = 200
  pool_path                  = "/infra/lb-pools/${var.name}-ingress"

}