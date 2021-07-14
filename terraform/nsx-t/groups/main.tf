resource "nsxt_policy_group" "groups" {
  display_name         = var.name
  nsx_id = var.name
  criteria {
    path_expression {
      member_paths = ["/infra/segments/${var.segment}"]
    }
  }

  
}