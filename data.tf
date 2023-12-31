data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_core_vnic_attachments" "app_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  instance_id         = oci_core_instance.master.id
}

data "oci_core_vnic" "app_vnic" {
  vnic_id = data.oci_core_vnic_attachments.app_vnics.vnic_attachments[0]["vnic_id"]
}

data "template_file" "master-boostrap" {
  template = file("./bootstrap-master.tpl")
  vars = {
    token_k3s = "${var.token_k3s}"
  }
}

data "template_file" "node-boostrap" {
  template = file("./bootstrap-node.tpl")
  vars = {
    master_private_ip = "${oci_core_instance.master.private_ip}"
    token_k3s         = "${var.token_k3s}"
  }
}
