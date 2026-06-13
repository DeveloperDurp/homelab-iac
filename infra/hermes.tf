module "hermes-agent" {
  source = "../modules/proxmox-vm"
  count  = local.hermes.count

  name        = local.hermes.name[count.index]
  target_node = local.hermes.node[count.index]
  vmid        = tonumber(local.hermes.vmid[count.index])
  template    = local.hermes.template
  tags        = local.hermes.tags
  cores       = local.hermes.cores
  memory      = local.hermes.memory
  storage     = local.hermes.storage
  drive_size  = local.hermes.drive
  vlan        = local.vlan
  ip_address  = local.hermes.ip[count.index]
  gateway     = local.gateway
  nameserver  = local.dnsserver
  sshkeys     = local.sshkeys
}
