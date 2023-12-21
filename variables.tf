variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key" {
}

variable "ssh_public_key" {
}

variable "ssh_private_key" {
}

variable "compartment_ocid" {
}

variable "region" {
  default = "sa-saopaulo-1"
}

variable "num_instances" {
  default = 2
}

variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "instance_image_ocid" {
  # See https://docs.oracle.com/en-us/iaas/images/
  # Canonical-Ubuntu-22.04-2023.09.28-0
  default = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa4dcybjf44hvj46xwkroaz4wlk5kshtppxebyimba2y3fh5g6d5ia"
}

variable "instance_ocpus" { default = 1 }

variable "instance_shape_config_memory_in_gbs" { default = 1 }

variable "token_k3s" {
}
