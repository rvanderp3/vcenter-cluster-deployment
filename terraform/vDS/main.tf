
provider "vsphere" {
  user           = "${var.vcenter_user}"
  password       = "${var.vcenter_password}"
  vsphere_server = "${var.vcenter_url}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "ignition" {
}

module "segment-portgroup" {
  source             = "./portgroup"
  count              = var.segment_count  
  vlan               = var.vlans[count.index]
  datacenter         = var.datacenter
  dvswitch           = "/datacenter/network/dvswitch"
  segment_name       = "ci-segment-${var.segment_start_number + count.index}"
}

module "segment-bastion" {
  source             = "./segment-bastion"
  count              = var.segment_count  
  segment            = "${var.segment_start_number + count.index}"
  segment_name       = "ci-segment-${var.segment_start_number + count.index}"
  dns                = var.segment_dns_server
  lease_timeout      = var.segment_dhcp_lease_timeout  
  public_key         = var.public_key
  datacenter         = var.datacenter
  datastore          = var.datastore
  source_network     = var.source_network
  cluster            = var.cluster
  depends_on = [
    module.segment-portgroup
  ]
}

