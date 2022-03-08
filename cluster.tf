resource "oci_containerengine_cluster" "px_oci_containerengine_cluster" {
  compartment_id = var.compartment_ocid
  endpoint_config {
    is_public_ip_enabled = "true"
    subnet_id = "${oci_core_subnet.kubernetes_api_endpoint_subnet.id}"
  }
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }
    admission_controller_options {
      is_pod_security_policy_enabled = "false"
    }
    service_lb_subnet_ids = [
      "${oci_core_subnet.service_lb_subnet.id}",
    ]
  }
  vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}

resource "oci_containerengine_node_pool" "px_oci_create_node_pool" {
  cluster_id = "${oci_containerengine_cluster.px_oci_containerengine_cluster.id}"
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name               = var.pool_name
  initial_node_labels {
    key   = "name"
    value = var.cluster_name
  }
  initial_node_labels {
    key   = "px/metadata-node"
    value = "true"
  }
  initial_node_labels {
    key   = "px/enabled"
    value = "true"
  }
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = "${oci_core_subnet.node_subnet.id}"
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
      subnet_id           = "${oci_core_subnet.node_subnet.id}"
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
      subnet_id           = "${oci_core_subnet.node_subnet.id}"
    }
    size = var.node_pool_size
  }
#  node_metadata	= {
#    user_data = base64encode(file("./userdata/bootstrap"))
#  }

  node_shape	= "VM.Standard.E3.Flex"
  node_shape_config {
    memory_in_gbs = "16"
    ocpus = "4"
  }

  node_source_details {
    image_id    = var.source_ocid
    source_type = "IMAGE"
  }

  ssh_public_key = "${file(var.ssh_public_key)}"
}
