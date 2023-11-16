terraform {

  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.18.0"
    }
  }
}

provider "oci" {
}
