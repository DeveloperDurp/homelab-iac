module "talos_dev_cluster" {
  source = "../modules/talos-cluster"

  gitlab_repo_id = local.gitlab_repo_id

  cluster_name     = local.talos.cluster_name
  cluster_endpoint = "https://${local.talos.cluster_dns}:6443"

  control_plane_ips = local.control.ip
  worker_ips        = local.worker.ip
  cluster_vip       = local.talos.cluster_vip

  # Dev specific tweaks
  allow_scheduling_on_control_planes = false

  # Ensure VMs are created before Talos tries to configure them
  depends_on = [
    module.talos_control,
    module.talos_worker
  ]
}

# Output the kubeconfig for manual verification or CI/CD
output "dev_kubeconfig" {
  value     = module.talos_dev_cluster.kubeconfig
  sensitive = true
}