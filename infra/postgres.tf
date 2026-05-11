module "k3s_masters" {
  # Use 'git::' prefix and append the branch/tag/commit with '?ref='
  source = "git::https://gitlab.durp.info/durfy/modules/terraform/proxmox-vm.git?ref=main"

  # Inputs
  count        = local.postgres.count
  vm_names     = local.postgres.name
  target_nodes = local.postgres.node
  vm_ips       = local.postgres.ip
  vlan         = local.vlan
  template     = local.template
  storage      = local.postgres.storage
  cores        = local.postgres.cores
  memory       = local.postgres.memory
  sshkeys      = local.sshkeys
  dnsserver    = local.dnsserver
  drive_size   = local.postgres.drive
}
