terraform {

  required_version = ">= 1.6.0, < 2.0.0"

  backend "remote" {
    organization = "lucasdiegorr"
    workspaces {
      name = "oci-cluster"
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.18.0"
    }
  }
}

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}
