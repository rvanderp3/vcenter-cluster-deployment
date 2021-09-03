
data "vsphere_datacenter" "labdc" {
  name = "${var.datacenter}"
}

data "vsphere_distributed_virtual_switch" "dvs"{
  name = "${var.dvswitch}"
}


resource "vsphere_distributed_port_group" "pg" {
   name                            = "${var.segment_name}"
    distributed_virtual_switch_uuid = "${data.vsphere_distributed_virtual_switch.dvs.id}"
    vlan_id = "${var.vlan}"
}