provider "proxmox" {
  pm_parallel                 = 1
  pm_tls_insecure             = true
  pm_api_url                  = var.pm_api_url
  pm_user                     = var.pm_user
  pm_password                 = var.pm_password
  pm_debug                    = false
  pm_minimum_permission_check = false
}

variable "pm_api_url" {
  description = "API URL to Proxmox provider"
  type        = string
}

variable "pm_password" {
  description = "Passowrd to Proxmox provider"
  type        = string
}

variable "pm_user" {
  description = "UIsername to Proxmox provider"
  type        = string
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