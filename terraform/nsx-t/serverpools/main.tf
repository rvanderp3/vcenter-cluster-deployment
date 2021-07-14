resource "nsxt_policy_lb_pool" "api-loadbalancer-pool" {
  display_name         = "${var.name}-api"
  nsx_id              = "${var.name}-api"
  algorithm            = "ROUND_ROBIN"
  min_active_members   = 1
  active_monitor_path  = "/infra/lb-monitor-profiles/..."
  
  member_group {
     group_path = "/infra/domains/default/groups/${var.name}"
  }

  snat {
    type = "AUTOMAP"
  }

  tcp_multiplexing_enabled = true
  tcp_multiplexing_number  = 8
}

resource "nsxt_policy_lb_pool" "ingress-loadbalancer-pool" {
  display_name         = "${var.name}-ingress"
  nsx_id              = "${var.name}-ingress"
  algorithm            = "ROUND_ROBIN"
  min_active_members   = 1
  active_monitor_path  = "/infra/lb-monitor-profiles/..."
  
  member_group {
     group_path = "/infra/domains/default/groups/${var.name}"
  }

  snat {
    type = "AUTOMAP"
  }

  tcp_multiplexing_enabled = true
  tcp_multiplexing_number  = 8
}