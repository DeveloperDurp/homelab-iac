#k3s
#-----------------------------------------------------

resource "proxmox_vm_qemu" "k3master" {
  count       = var.k3master.count
  ciuser      = "administrator"
  vmid        = "20${var.ipprefix}${var.k3master.ip[count.index]}"
  name        = "${var.k3master.name[count.index]}-${var.environment}"
  target_node = var.k3master.node[count.index]
  clone       = var.template
  qemu_os     = "other"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = var.k3master.cores
  sockets     = 1
  cpu         = "host"
  memory      = var.k3master.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = var.k3master.drive
    type    = "scsi"
    format  = "raw"
    storage = var.k3master.storage
    ssd     = 1
    backup  = false
  }
  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.20.${var.ipprefix}${var.k3master.ip[count.index]}/24,gw=192.168.20.1"
  searchdomain = "durp.loc"
  nameserver   = var.dnsserver
  sshkeys      = var.sshkeys
}

resource "proxmox_vm_qemu" "k3server" {
  count       = var.k3server.count
  ciuser      = "administrator"
  vmid        = "20${var.ipprefix}${var.k3server.ip[count.index]}"
  name        = "${var.k3server.name[count.index]}-${var.environment}"
  target_node = var.k3server.node[count.index]
  clone       = var.template
  qemu_os     = "other"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = var.k3server.cores
  sockets     = 1
  cpu         = "host"
  memory      = var.k3server.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = var.k3server.drive
    type    = "scsi"
    format  = "raw"
    storage = var.k3server.storage
    ssd     = 1
    backup  = false
  }
  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.20.${var.ipprefix}${var.k3server.ip[count.index]}/24,gw=192.168.20.1"
  searchdomain = "durp.loc"
  nameserver   = var.dnsserver
  sshkeys      = var.sshkeys
}
