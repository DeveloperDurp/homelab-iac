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

resource "proxmox_vm_qemu" "control" {
  count       = local.control.count
  ciuser      = "administrator"
  description = "Managed by OpenTofu"
  vmid        = local.control.vmid[count.index]
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
  memory             = local.control.memory
  scsihw             = "virtio-scsi-pci"
  boot               = "order=scsi0"
  start_at_node_boot = true
  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }
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
  vmid        = local.worker.vmid[count.index]
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
  memory             = local.worker.memory
  scsihw             = "virtio-scsi-pci"
  boot               = "order=scsi0"
  start_at_node_boot = true
  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }
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
  ipconfig0    = "ip=${local.worker.ip[count.index]}/24,gw=${local.gateway}"
  searchdomain = "durp.loc"
  nameserver   = local.dnsserver
}
