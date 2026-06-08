output "talos_config" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}

output "machine_secrets" {
  value     = talos_machine_secrets.machine_secrets
  sensitive = true
}