resource "oci_core_instance" "px-bastion" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id      = var.compartment_ocid

  agent_config {

    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = "px-bastion-vnic"
    subnet_id        = "${oci_core_subnet.px-bastion_subnet.id}"
  }

  display_name = "px-bastion"

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key)}"
  }

  shape = "VM.Standard.E2.1.Micro"
  source_details {
    source_id   = "ocid1.image.oc1.uk-london-1.aaaaaaaaqczqe2zjngetuqscokur45xtw76nqp7lyxk6o23uvtwtcv5bdvba"
    source_type = "image"
  }

#  state = var.bastion_state

  timeouts {
    create = "60m"
  }

}
