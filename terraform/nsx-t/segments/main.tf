resource "nsxt_policy_segment" "segments" {
  display_name        = var.name
  nsx_id              = var.name
  domain_name         = var.domain_name
  transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/...."
  connectivity_path   = "/infra/tier-1s/your-t1"
  dhcp_config_path    = "/infra/dhcp-server-configs/dhcp-profile"
  subnet {
    cidr        = var.cidr
    dhcp_ranges = var.dhcp_ranges
    dhcp_v4_config {
      dns_servers = var.dns_servers
      lease_time  = var.dhcp_lease_timeout
      server_address = var.dhcp_server
    }
  }
}


