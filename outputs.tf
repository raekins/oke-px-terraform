# Output the "list" of all availability domains.
output "all-availability-domains-in-your-tenancy" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains[*].name}"
}

output "all-running-oke-instance-names" {
  value = "${data.oci_core_instances.oke_instances.instances[*].display_name}"
}

output "selected-core-services" {
  value = "${data.oci_core_services.core_services.services[*].name}"
}

output "containerengine-cluster-name" {
  value = "${data.oci_containerengine_clusters.px_cluster.name}"
}

output "containerengine-cluster-kubernetes_version" {
  value = "${data.oci_containerengine_clusters.px_cluster.clusters[0].kubernetes_version}"
}

output "containerengine-cluster-public-endpoint" {
  value = "${data.oci_containerengine_clusters.px_cluster.clusters[0].endpoints[0].public_endpoint}"
}

#output "px-cluster-content" {
#  value = "${data.oci_containerengine_cluster_kube_config.px_kubeconfig.content}"
#}

#output "kubernetes-version" {
#  value = "${data.kubectl_server_version.current}"
#}
