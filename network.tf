resource "oci_core_virtual_network" "oci_homelab_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "ociHomelabVCN"
  dns_label      = "ocihlvcn"
}

resource "oci_core_subnet" "oci_homelab_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "ociHomelabSubnet"
  dns_label         = "ocihlsubnet"
  security_list_ids = [oci_core_security_list.oci_homelab_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.oci_homelab_vcn.id
  route_table_id    = oci_core_route_table.oci_homelab_route_table.id
  dhcp_options_id   = oci_core_virtual_network.oci_homelab_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "oci_homelab_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "OciHomelabIG"
  vcn_id         = oci_core_virtual_network.oci_homelab_vcn.id
}

resource "oci_core_route_table" "oci_homelab_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oci_homelab_vcn.id
  display_name   = "OciHomelabRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.oci_homelab_internet_gateway.id
  }
}

resource "oci_core_security_list" "oci_homelab_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oci_homelab_vcn.id
  display_name   = "OciHomelabSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "10.1.20.0/24"

    tcp_options {
      max = "2377"
      min = "2377"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }
}
