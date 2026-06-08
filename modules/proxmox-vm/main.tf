terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "0.41.25"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  target_node = var.target_node
  vmid        = var.vmid
  description = var.desc
  tags        = var.tags

  # Logic to handle both template-based and new VMs
  clone      = var.template
  full_clone = var.template != null ? true : false

  qemu_os = "l26"
  os_type = "cloud-init"
  agent   = 1

  lifecycle {
    prevent_destroy = true
  }

  cpu {
    cores = var.cores
    type  = "x86-64-v2-AES"
  }

  memory = var.memory
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0"

  start_at_node_boot = true
  sshkeys            = var.sshkeys
  ciuser             = var.ciuser

  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }

  vga { type = "serial0" }
  serial {
    id   = 0
    type = "socket"
  }

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.drive_size
          format  = var.format
          storage = var.storage
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.vlan
  }

  ipconfig0    = "ip=${var.ip_address}/24,gw=${var.gateway}"
  searchdomain = var.searchdomain
  nameserver   = var.nameserver
}