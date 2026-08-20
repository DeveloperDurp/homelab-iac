terraform {
  backend "http" {}
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "19.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.15.3"
    }
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "0.41.25"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.9.0"
    }
  }
}

locals {
  gitlab_repo_id = "7"
  template       = "talos-Template"
  sshkeys        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEphzWgwUZnvL6E5luKLt3WO0HK7Kh63arSMoNl5gmjzXyhG1DDW0OKfoIl0T+JZw/ZjQ7iii6tmSLFRk6nuYCldqe5GVcFxvTzX4/xGEioAyG0IiUGKy6s+9xzO8QXF0EtSNPH0nfHNKcCjgwWAzM+Lt6gW0Vqs+aU5ICuDiEchmvYPz+rBaVldJVTG7m3ogKJ2aIF7HU/pCPp5l0E9gMOw7s0ABijuc3KXLEWCYgL39jIST6pFH9ceRLmu8Xy5zXHAkkEEauY/e6ld0hlzLadiUD7zYJMdDcm0oRvenYcUlaUl9gS0569IpfsJsjCejuqOxCKzTHPJDOT0f9TbIqPXkGq3s9oEJGpQW+Z8g41BqRpjBCdBk+yv39bzKxlwlumDwqgx1WP8xxKavAWYNqNRG7sBhoWwtxYEOhKXoLNjBaeDRnO5OY5AQJvONWpuByyz0R/gTh4bOFVD+Y8WWlKbT4zfhnN70XvapRsbZiaGhJBPwByAMGg6XxSbC6xtbyligVGCEjCXbTLkeKq1w0DuItY+FBGO3J2k90OiciTVSeyiVz9J/Y03UB0gHdsMCoVNrj+9QWfrTLDhM7D5YrXUt5nj2LQTcbtf49zoQXWxUhozlg42E/FJU/Yla7y55qWizAEVyP2/Ks/PHrF679k59HNd2IJ/aicA9QnmWtLQ== ansible"
  #template   = "Debian12-Template"
  storage    = "cache-domains"
  emulatessd = true
  format     = "raw"
  dnsserver  = "192.168.${local.vlan}.1"
  gateway    = "192.168.${local.vlan}.1"
  vlan       = 98
  control = {
    tags  = "control_dmz"
    count = 3
    name = [
      "control01-dmz",
      "control02-dmz",
      "control03-dmz"
    ]
    cores   = 2
    memory  = "4096"
    drive   = 20
    storage = "cache-domains"
    node = [
      "mothership",
      "overlord",
      "vanguard"
    ]
    vmid = [
      "${local.vlan}14",
      "${local.vlan}15",
      "${local.vlan}16"
    ]
    ip = [
      "192.168.${local.vlan}.14",
      "192.168.${local.vlan}.15",
      "192.168.${local.vlan}.16"
    ]
  }
  worker = {
    tags  = "worker_dmz"
    count = 3
    name = [
      "worker01-dmz",
      "worker02-dmz",
      "worker03-dmz"
    ]
    cores   = 4
    memory  = "8192"
    drive   = 120
    storage = "cache-domains"
    node = [
      "mothership",
      "overlord",
      "vanguard"
    ]
    vmid = [
      "${local.vlan}24",
      "${local.vlan}25",
      "${local.vlan}26"
    ]
    ip = [
      "192.168.${local.vlan}.24",
      "192.168.${local.vlan}.25",
      "192.168.${local.vlan}.26"
    ]
  }
  talos = {
    cluster_name = "dmz"
    cluster_dns  = "kube.dmz.durp.loc"
    cluster_vip  = "192.168.${local.vlan}.9"
  }
  templateOld = "Debian12-Template"
  k3smaster = {
    tags    = "k3s_dmz"
    count   = 3
    name    = ["master01-dmz", "master02-dmz", "master03-dmz"]
    cores   = 2
    memory  = "4096"
    drive   = 20
    storage = "cache-domains"
    node    = ["mothership", "overlord", "vanguard"]
    ip      = ["11", "12", "13"]
  }
  k3sserver = {
    tags    = "k3s_dmz"
    count   = 3
    name    = ["node01-dmz", "node02-dmz", "node03-dmz"]
    cores   = 4
    memory  = "8192"
    drive   = 240
    storage = "cache-domains"
    node    = ["mothership", "overlord", "vanguard"]
    ip      = ["21", "22", "23"]
  }
  openVPN = {
    tags    = "openvpn"
    count   = 1
    name    = ["openVPN"]
    cores   = 2
    memory  = "4096"
    drive   = 20
    storage = "cache-domains"
    node    = ["mothership"]
    ip      = ["20"]
  }
  matrix = {
    tags    = "matrix"
    count   = 1
    name    = ["matrix"]
    cores   = 2
    memory  = "4096"
    drive   = 60
    storage = "cache-domains"
    node    = ["vanguard"]
    ip      = ["21"]
  }
}
