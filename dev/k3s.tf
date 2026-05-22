resource "proxmox_vm_qemu" "control" {
  count       = local.control.count
  ciuser      = "administrator"
  description = "Managed by OpenTofu"
  vmid        = "${local.vlan}${local.control.ip[count.index]}"
  name        = local.control.name[count.index]
  target_node = local.control.node[count.index]
  clone       = local.template
  tags        = local.control.tags
  qemu_os     = "l26"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cpu {
    cores = local.control.cores
    type  = "x86-64-v2-AES"
  }
  sockets  = 1
  cpu_type = "host"
  memory   = local.control.memory
  scsihw   = "virtio-scsi-pci"
  boot     = "order=scsi0"
  onboot   = true
  sshkeys  = local.sshkeys
  vga {
    type = "serial0"
  }
  serial {
    id   = 0
    type = "socket"
  }
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = local.control.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = local.control.drive
          format  = local.format
          storage = local.control.storage
        }
      }
    }
  }
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.vlan
  }

  #Cloud Init Settings
  ipconfig0    = "ip=${local.control.ip[count.index]}/24,gw=${local.gateway}"
  searchdomain = "durp.loc"
  nameserver   = local.dnsserver
}

resource "proxmox_vm_qemu" "worker" {
  count       = local.worker.count
  ciuser      = "administrator"
  description = "Managed by OpenTofu"
  vmid        = "${local.vlan}${local.worker.ip[count.index]}"
  name        = local.worker.name[count.index]
  target_node = local.worker.node[count.index]
  clone       = local.template
  tags        = local.worker.tags
  qemu_os     = "l26"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cpu {
    cores = local.worker.cores
    type  = "x86-64-v2-AES"
  }
  sockets  = 1
  cpu_type = "host"
  memory   = local.worker.memory
  scsihw   = "virtio-scsi-pci"
  boot     = "order=scsi0"
  onboot   = true
  sshkeys  = local.sshkeys
  vga {
    type = "serial0"
  }
  serial {
    id   = 0
    type = "socket"
  }
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = local.worker.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = local.worker.drive
          format  = local.format
          storage = local.worker.storage
        }
      }
    }
  }
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.vlan
  }

  #Cloud Init Settings
  ipconfig0    = "ip=${local.control.ip[count.index]}/24,gw=${local.gateway}"
  searchdomain = "durp.loc"
  nameserver   = local.dnsserver
}
