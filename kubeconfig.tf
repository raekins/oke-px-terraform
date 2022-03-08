resource "local_file" "kubeconfig" {
  content  = "${data.oci_containerengine_cluster_kube_config.px_kubeconfig.content}"
  filename = ".kube/config"
}

#provider "kubectl" {
#  config_path       = ".kube/config"  
#  apply_retry_count = 5
#  load_config_file  = "true"
#}
