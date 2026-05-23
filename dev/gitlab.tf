provider "gitlab" {
  token    = var.gitlab_token
  base_url = "https://gitlab.durp.info/api/v4/"
}

variable "gitlab_token" {
  description = "Gitlab Token"
  type        = string
}

resource "gitlab_project_variable" "talosconfig" {
  project       = local.gitlab.iacRepoId
  key           = "${local.talos.cluster_name}_TALOSCONFIG"
  value         = data.talos_client_configuration.talosconfig.talos_config
  variable_type = "file"
}

resource "gitlab_project_variable" "kubeconfig" {
  project       = local.gitlab.iacRepoId
  key           = "${local.talos.cluster_name}_KUBECONFIG"
  value         = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  variable_type = "file"
}
