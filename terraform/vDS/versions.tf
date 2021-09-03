terraform {
  required_providers {
    ignition = {
      source = "community-terraform-providers/ignition"
      version = "2.1.2"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}