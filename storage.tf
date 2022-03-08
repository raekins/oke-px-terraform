resource "oci_core_volume" "px_oci_volume" {
  count               = var.node_pool_size

  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[count.index].name
  display_name        = join("-",[var.cluster_name, "AD", (count.index)+1])
  size_in_gbs         = var.node_pool_px_volume_size_in_gbs
}

resource "oci_core_volume_attachment" "px_oci_volume_attach" {
  count               = var.node_pool_size

  attachment_type     = var.attachment_type
  device              = "/dev/oracleoci/oraclevdb"
  instance_id         = "${data.oci_core_instances.oke_instances.instances[count.index].id}"
#  instance_id         = "${local.instance_id[count.index]}"
  volume_id           = "${oci_core_volume.px_oci_volume[count.index].id}"
  display_name        = join("-",[var.cluster_name, count.index])

  depends_on          = [ 
                          oci_containerengine_node_pool.px_oci_create_node_pool,
                          oci_core_volume.px_oci_volume
                        ]
}
