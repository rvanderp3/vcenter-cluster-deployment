
variable "segment_count" {
  type = number
}
variable "segment_start_number" {
  type = number
}

variable "segment_dhcp_lease_timeout" {
  type = string
}

variable "segment_dns_server" {
  type = string
}

variable "vcenter_user" {
  type = string
}

variable "vcenter_password" {
  type = string
}

variable "vcenter_url" {
  type = string
}

variable "public_key" {
  type = string
}

variable "datastore" {
  type = string
}

variable "datacenter" {
  type = string
}

variable "source_network" {
    type = string
}

variable "cluster" {
  type = string
}

variable "vlans" {
  type = list
}