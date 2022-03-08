resource "null_resource" "px-operator" {
  provisioner "local-exec" {
    command = "kubectl apply -f '${var.px_oper_url}'"
  }
  depends_on = [
    local_file.kubeconfig
  ]
}

resource "time_sleep" "wait_for_px-operator" {
  create_duration = "30s"
  
  depends_on = [null_resource.px-operator]
}

resource "null_resource" "px-spec" {
  provisioner "local-exec" {
    command  = "kubectl apply -f '${var.px_spec_url}'"
  }
  depends_on = [time_sleep.wait_for_px-operator]
}
