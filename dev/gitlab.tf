resource "gitlab_project_variable" "talosconfig" {
  project       = var.gitlab_project_id
  key           = "DEV_TALOSCONFIG"
  value         = data.talos_client_configuration.talosconfig.talos_config
  variable_type = "file"
}

resource "gitlab_project_variable" "kubeconfig" {
  project       = var.gitlab_project_id
  key           = "DEV_KUBECONFIG"
  value         = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  variable_type = "file"
}
