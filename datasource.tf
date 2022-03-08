data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_containerengine_node_pool_option" "node_pool_options" {
  node_pool_option_id = oci_containerengine_cluster.px_oci_containerengine_cluster.id
}

data "oci_core_services" "core_services" {
  filter {
    name   = "name"
    values = [ "All LHR Services In Oracle Services Network" ]
  }
}

data "oci_core_instances" "oke_instances" {
  #Required
  compartment_id = var.compartment_ocid
  state          = "RUNNING"
  filter {
    name   = "display_name"
    values = [ "^oke" ]
    regex  = true
  }
  depends_on = [ 
    oci_containerengine_node_pool.px_oci_create_node_pool
  ]
}

data "oci_containerengine_clusters" "px_cluster" {
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  name           = var.cluster_name
  state          = ["ACTIVE"]

  depends_on = [
    oci_containerengine_cluster.px_oci_containerengine_cluster
  ]
}

data "oci_containerengine_cluster_kube_config" "px_kubeconfig" {
  #Required
  cluster_id = "${oci_containerengine_cluster.px_oci_containerengine_cluster.id}"
  depends_on = [
    oci_containerengine_node_pool.px_oci_create_node_pool
  ]
}

#data "kubectl_server_version" "current" {
#  depends_on = [
#    data.oci_containerengine_cluster_kube_config.px_kubeconfig
#  ]
#}
