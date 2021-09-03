data "template_file" "dhcp-conf" {
  template = "${file("${path.module}/dhcp.conf.tmpl")}"
  vars = {
    segment_number = "${var.segment}"
  }
}

data "template_file" "network-conf-ens192" {
  template = "${file("${path.module}/ens192.tmpl")}"
  vars = {
    segment_number = "${var.segment}"
    dns = "${var.dns}"
  }
}

data "template_file" "network-conf-ens224" {
  template = "${file("${path.module}/ens224.tmpl")}"
  vars = {
    segment_number = "${var.segment}"
    dns = "${var.dns}"
  }
}

data "ignition_directory" "dnsmasq_d" {
    path = "/etc/dnsmasq.q"
}

data "ignition_user" "core" {
    name = "core"
    password_hash = ""
    ssh_authorized_keys = [ 
      "${var.public_key}"      
    ]
}

data "ignition_file" "dhcp-conf" {
    path = "/etc/dnsmasq.d/dhcp.conf"
    content {
        content = "${data.template_file.dhcp-conf.rendered}"
    }
    uid = "0"
    gid = "0"
}

data "ignition_file" "routing-script" {
    path = "/etc/load-rules.sh"
    content {
        content = "${file("${path.module}/load-rules.sh")}"
    }
    uid = "0"
    gid = "0"
    mode = 493
}

data "ignition_file" "networkcfg-script-ens192" {
    path = "/etc/NetworkManager/system-connections/Wired connection 1.nmconnection"
    content {
        content = "${data.template_file.network-conf-ens192.rendered}"
    }
    uid = "0"
    gid = "0"
    mode = 384
}

data "ignition_file" "networkcfg-script-ens224" {
    path = "/etc/NetworkManager/system-connections/Wired connection 2.nmconnection"
    content {
        content = "${data.template_file.network-conf-ens224.rendered}"
    }
    uid = "0"
    gid = "0"
    mode = 384
}

data "ignition_file" "iptables-conf" {
    path = "/etc/iptables-rules"
    content {
        content = "${file("${path.module}/iptables-rules")}"
    }
    uid = "0"
    gid = "0"
}

data "ignition_systemd_unit" "network-config" {
    name = "network-config.service"
    content = "${file("${path.module}/network-config.unit")}"
}

data "ignition_systemd_unit" "routing" {
    name = "routing.service"
    content = "${file("${path.module}/routing.unit")}"
}

data "ignition_config" "bastion-ignition" {
  files = [
    data.ignition_directory.dnsmasq_d.rendered,
    data.ignition_file.dhcp-conf.rendered,    
    data.ignition_file.networkcfg-script-ens192.rendered,
    data.ignition_file.networkcfg-script-ens224.rendered,    
    data.ignition_file.iptables-conf.rendered,
    data.ignition_file.routing-script.rendered,
  ]
  users = [
    data.ignition_user.core.rendered,
  ]
  systemd = [
     data.ignition_systemd_unit.routing.rendered,
  ]
}

data "ignition_config" "test-ignition" {
  files = [
  ]
  users = [
    data.ignition_user.core.rendered,
  ]
  systemd = [
  ]
}


data "vsphere_datacenter" "labdc" {
  name = "${var.datacenter}"
}

data "vsphere_network" "external_network" {
  name          = "${var.source_network}"
  datacenter_id = "${data.vsphere_datacenter.labdc.id}"
}

data "vsphere_network" "internal_network" {
  name          = "ci-segment-${var.segment}"
  datacenter_id = "${data.vsphere_datacenter.labdc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.labdc.id}"
}

data "vsphere_compute_cluster" "labcluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.labdc.id}"
}

data "vsphere_virtual_machine" "template" {
  name = "fedora-coreos-34.20210808.3.0-vmware.x86_64"
  datacenter_id = "${data.vsphere_datacenter.labdc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.segment_name}-bastion"
  resource_pool_id = "${data.vsphere_compute_cluster.labcluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 8192
  guest_id = "rhel7_64Guest"

  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = "${data.vsphere_network.external_network.id}"
  }

  network_interface {
    network_id = "${data.vsphere_network.internal_network.id}"
  }

clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  vapp {
    properties = {
      "guestinfo.ignition.config.data" = base64encode("${data.ignition_config.bastion-ignition.rendered}")
      "guestinfo.ignition.config.data.encoding" = "base64"
    }
  }

  disk {
    label = "disk0"
    size  = 20
  }
}

resource "vsphere_virtual_machine" "vm-test" {
  name             = "${var.segment_name}-test"
  resource_pool_id = "${data.vsphere_compute_cluster.labcluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 8192
  guest_id = "rhel7_64Guest"

  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = "${data.vsphere_network.internal_network.id}"
  }

clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  vapp {
    properties = {
      "guestinfo.ignition.config.data" = base64encode("${data.ignition_config.test-ignition.rendered}")
      "guestinfo.ignition.config.data.encoding" = "base64"
    }
  }

  disk {
    label = "disk0"
    size  = 20
  }
}