segment_subnet      = "192.168"
segment_subnet_mask = 24
segment_count       = 24
segment_domain_name = "your-domain"
segment_start_number = 1
segment_name = "seg-name-prefix"

segment_load_balancer_start = 128
segment_load_balancer = "10.x.x"

segment_dhcp_start = 10
segment_dhcp_end   = 99
segment_dhcp_lease_timeout = 3600
segment_dns_servers = ["10.x.x.x"]
username = "nsxt-user"
password = "nsxt-password"
lb_path = "/infra/lb-services/<load balancer name>"
nsxt_proxy_host = "<nsxt-hostname>"
