terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "0.41.25"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "19.0"
    }
  }
}

resource "unifi_dns_record" "cluster_endpoint" {
  name        = replace(replace(var.cluster_endpoint, "https://", ""), "/:[0-9]+$/", "")
  record_type = "A"
  value       = var.cluster_vip
  enabled     = true
  ttl         = 300
}

resource "gitlab_project_variable" "talosconfig" {
  project       = var.gitlab_repo_id
  key           = "${var.cluster_name}_TALOSCONFIG"
  value         = data.talos_client_configuration.talosconfig.talos_config
  variable_type = "file"
}

resource "gitlab_project_variable" "kubeconfig" {
  project       = var.gitlab_repo_id
  key           = "${var.cluster_name}_KUBECONFIG"
  value         = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  variable_type = "file"
}

resource "talos_machine_secrets" "machine_secrets" {}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = var.control_plane_ips
}

data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets

  config_patches = [
    yamlencode({
      cluster = {
        allowSchedulingOnControlPlanes = var.allow_scheduling_on_control_planes
      }
      machine = {
        network = {
          interfaces = [
            {
              interface = "eth0"
              vip = {
                ip = var.cluster_vip
              }
            }
          ]
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  count                       = length(var.control_plane_ips)
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  node                        = var.control_plane_ips[count.index]
}

data "talos_machine_configuration" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "worker_config_apply" {
  count                       = length(var.worker_ips)
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_worker.machine_configuration
  node                        = var.worker_ips[count.index]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.control_plane_ips[0]
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.control_plane_ips[0]
}