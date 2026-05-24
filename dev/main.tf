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
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.2.0"
    }
  }
}

locals {
  gitlab = {
    iacRepoId = "7"
  }
  sshkeys   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEphzWgwUZnvL6E5luKLt3WO0HK7Kh63arSMoNl5gmjzXyhG1DDW0OKfoIl0T+JZw/ZjQ7iii6tmSLFRk6nuYCldqe5GVcFxvTzX4/xGEioAyG0IiUGKy6s+9xzO8QXF0EtSNPH0nfHNKcCjgwWAzM+Lt6gW0Vqs+aU5ICuDiEchmvYPz+rBaVldJVTG7m3ogKJ2aIF7HU/pCPp5l0E9gMOw7s0ABijuc3KXLEWCYgL39jIST6pFH9ceRLmu8Xy5zXHAkkEEauY/e6ld0hlzLadiUD7zYJMdDcm0oRvenYcUlaUl9gS0569IpfsJsjCejuqOxCKzTHPJDOT0f9TbIqPXkGq3s9oEJGpQW+Z8g41BqRpjBCdBk+yv39bzKxlwlumDwqgx1WP8xxKavAWYNqNRG7sBhoWwtxYEOhKXoLNjBaeDRnO5OY5AQJvONWpuByyz0R/gTh4bOFVD+Y8WWlKbT4zfhnN70XvapRsbZiaGhJBPwByAMGg6XxSbC6xtbyligVGCEjCXbTLkeKq1w0DuItY+FBGO3J2k90OiciTVSeyiVz9J/Y03UB0gHdsMCoVNrj+9QWfrTLDhM7D5YrXUt5nj2LQTcbtf49zoQXWxUhozlg42E/FJU/Yla7y55qWizAEVyP2/Ks/PHrF679k59HNd2IJ/aicA9QnmWtLQ== ansible"
  template  = "tails-Template"
  format    = "raw"
  dnsserver = "192.168.${local.vlan}.1"
  gateway   = "192.168.${local.vlan}.1"
  vlan      = 10
  control = {
    tags  = "control_dev"
    count = 3
    name = [
      "control01-dev",
      "control02-dev",
      "control03-dev"
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
      "${local.vlan}11",
      "${local.vlan}12",
      "${local.vlan}13"
    ]
    ip = [
      "192.168.${local.vlan}.11",
      "192.168.${local.vlan}.12",
      "192.168.${local.vlan}.13"
    ]
  }
  worker = {
    tags  = "worker_dev"
    count = 3
    name = [
      "worker01-dev",
      "worker02-dev",
      "worker03-dev"
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
      "${local.vlan}21",
      "${local.vlan}22",
      "${local.vlan}23"
    ]
    ip = [
      "192.168.${local.vlan}.21",
      "192.168.${local.vlan}.22",
      "192.168.${local.vlan}.23"
    ]
  }
  talos = {
    cluster_name = "dev"
    cluster_dns  = "kube.dev.durp.loc"

  }
}
