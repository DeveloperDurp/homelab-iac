# Dedicated NetBird server VM (docker compose, combined netbird-server image)
# Same pattern as openVPN.tf: Debian12-Template clone on VLAN 98.
resource "proxmox_vm_qemu" "netbird" {
  count       = local.netbird.count
  ciuser      = "administrator"
  vmid        = "${local.vlan}${local.netbird.ip[count.index]}"
  name        = local.netbird.name[count.index]
  target_node = local.netbird.node[count.index]
  clone       = local.templateOld
  tags        = local.netbird.tags
  qemu_os     = "l26"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = local.netbird.cores
  sockets     = 1
  cpu_type    = "host"
  memory      = local.netbird.memory
  scsihw      = "virtio-scsi-pci"
  boot        = "order=virtio0"
  onboot      = true
  sshkeys     = local.sshkeys
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
          storage = local.storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = local.netbird.drive
          format  = local.format
          storage = local.storage
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
  ipconfig0    = "ip=192.168.${local.vlan}.${local.netbird.ip[count.index]}/24,gw=192.168.${local.vlan}.1"
  searchdomain = "durp.loc"
  nameserver   = local.dnsserver
}

locals {
  # exported for DNS record
  netbird_ip = "192.168.${local.vlan}.${local.netbird.ip[0]}"
}

resource "unifi_dns_record" "netbird" {
  name        = "netbird.durp.loc"
  enabled     = true
  record_type = "A"
  ttl         = 300
  value       = local.netbird_ip
}
