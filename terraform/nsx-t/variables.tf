
variable "segment_count" {
  type = number
}
variable "segment_start_number" {
  type = number
}

variable "segment_domain_name" {
  type = string
}
variable "segment_name" {
  type = string
}

variable "segment_load_balancer" {
  type = string
}

variable "segment_load_balancer_start" {
  type = number
}

variable "lb_path" {
  type = string
}

variable "segment_dhcp_start" {
  type = number
}
variable "segment_dhcp_end" {
  type = number
}
variable "segment_dhcp_lease_timeout" {
  type = number
}


variable "segment_subnet" {
  type = string
}

variable "segment_subnet_mask" {
  type = number
}
variable "segment_dns_servers" {
  type = list(string)
}



variable "username" {
  type = string
}
variable "password" {
  type = string
}
variable "nsxt_proxy_host" {
  type = string
}
