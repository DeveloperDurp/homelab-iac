provider "unifi" {
  api_url        = var.unifi_api_url
  api_key        = var.unifi_api_key
  allow_insecure = true
}

module "talos_control" {
  source = "../modules/proxmox-vm"
  count  = local.control.count

  name        = local.control.name[count.index]
  target_node = local.control.node[count.index]
  vmid        = tonumber(local.control.vmid[count.index])
  template    = local.template
  tags        = local.control.tags
  cores       = local.control.cores
  memory      = local.control.memory
  storage     = local.control.storage
  drive_size  = local.control.drive
  vlan        = local.vlan
  ip_address  = local.control.ip[count.index]
  gateway     = local.gateway
  nameserver  = local.dnsserver
}

module "talos_worker" {
  source = "../modules/proxmox-vm"
  count  = local.worker.count

  name        = local.worker.name[count.index]
  target_node = local.worker.node[count.index]
  vmid        = tonumber(local.worker.vmid[count.index])
  template    = local.template
  tags        = local.worker.tags
  cores       = local.worker.cores
  memory      = local.worker.memory
  storage     = local.worker.storage
  drive_size  = local.worker.drive
  vlan        = local.vlan
  ip_address  = local.worker.ip[count.index]
  gateway     = local.gateway
  nameserver  = local.dnsserver
}

module "talos_infra_cluster" {
  source = "../modules/talos-cluster"

  gitlab_repo_id = local.gitlab_repo_id

  cluster_name     = local.talos.cluster_name
  cluster_endpoint = "https://${local.talos.cluster_dns}:6443"

  control_plane_ips = local.control.ip
  worker_ips        = local.worker.ip
  cluster_vip       = local.talos.cluster_vip

  # infra specific tweaks
  allow_scheduling_on_control_planes = false

  # Ensure VMs are created before Talos tries to configure them
  depends_on = [
    module.talos_control,
    module.talos_worker
  ]
}

# Output the kubeconfig for manual verification or CI/CD
output "infra_kubeconfig" {
  value     = module.talos_infra_cluster.kubeconfig
  sensitive = true
}

output "infra_talosconfig" {
  value     = module.talos_infra_cluster.talos_config
  sensitive = true
}
