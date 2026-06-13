terraform {
  backend "http" {}
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
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
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.29.0"
    }
  }
}

provider "proxmox" {
  pm_parallel     = 1
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_debug        = false
}

locals {
  gitlab_repo_id = "7"
  template       = "tails-Template"
  format         = "raw"
  dnsserver      = "192.168.${local.vlan}.1"
  gateway        = "192.168.${local.vlan}.1"
  vlan           = 12
  control = {
    tags  = "control_infra"
    count = 3
    name = [
      "control01-infra",
      "control02-infra",
      "control03-infra"
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
    tags  = "worker_infra"
    count = 3
    name = [
      "worker01-infra",
      "worker02-infra",
      "worker03-infra"
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
  hermes = {
    tags  = "hermes"
    template = "Debian12-Template"
    count = 1
    name = [
      "hermes-agent",
    ]
    cores   = 8
    memory  = "16384"
    drive   = 200
    storage = "cache-domains"
    node = [
      "mothership",
    ]
    vmid = [
      "${local.vlan}50",
    ]
    ip = [
      "192.168.${local.vlan}.50",
    ]
  }
  talos = {
    cluster_name = "infra"
    cluster_dns  = "kube.infra.durp.loc"
    cluster_vip  = "192.168.12.9"
  }
#----
  sshkeys   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEphzWgwUZnvL6E5luKLt3WO0HK7Kh63arSMoNl5gmjzXyhG1DDW0OKfoIl0T+JZw/ZjQ7iii6tmSLFRk6nuYCldqe5GVcFxvTzX4/xGEioAyG0IiUGKy6s+9xzO8QXF0EtSNPH0nfHNKcCjgwWAzM+Lt6gW0Vqs+aU5ICuDiEchmvYPz+rBaVldJVTG7m3ogKJ2aIF7HU/pCPp5l0E9gMOw7s0ABijuc3KXLEWCYgL39jIST6pFH9ceRLmu8Xy5zXHAkkEEauY/e6ld0hlzLadiUD7zYJMdDcm0oRvenYcUlaUl9gS0569IpfsJsjCejuqOxCKzTHPJDOT0f9TbIqPXkGq3s9oEJGpQW+Z8g41BqRpjBCdBk+yv39bzKxlwlumDwqgx1WP8xxKavAWYNqNRG7sBhoWwtxYEOhKXoLNjBaeDRnO5OY5AQJvONWpuByyz0R/gTh4bOFVD+Y8WWlKbT4zfhnN70XvapRsbZiaGhJBPwByAMGg6XxSbC6xtbyligVGCEjCXbTLkeKq1w0DuItY+FBGO3J2k90OiciTVSeyiVz9J/Y03UB0gHdsMCoVNrj+9QWfrTLDhM7D5YrXUt5nj2LQTcbtf49zoQXWxUhozlg42E/FJU/Yla7y55qWizAEVyP2/Ks/PHrF679k59HNd2IJ/aicA9QnmWtLQ== ansible"
  templateOld  = "Debian12-Template"
  k3smaster = {
    tags    = "k3s_infra"
    count   = 3
    name    = ["master01-infra", "master02-infra", "master03-infra"]
    cores   = 2
    memory  = "4096"
    drive   = 20
    storage = "cache-domains"
    node    = ["mothership", "overlord", "vanguard"]
    ip      = ["11", "12", "13"]
  }
  k3sserver = {
    tags    = "k3s_infra"
    count   = 3
    name    = ["node01-infra", "node02-infra", "node03-infra"]
    cores   = 4
    memory  = "16384"
    drive   = 240
    storage = "cache-domains"
    node    = ["mothership", "overlord", "vanguard"]
    ip      = ["21", "22", "23"]
  }
  #haproxy = {
  #  tags    = "haproxy"
  #  count   = 3
  #  name    = ["haproxy-01", "haproxy-02", "haproxy-03"]
  #  cores   = 2
  #  memory  = "1024"
  #  drive   = 20
  #  storage = "cache-domains"
  #  node    = ["mothership", "overlord", "vanguard"]
  #  ip      = ["31", "32", "33"]
  #}
  #postgres = {
  #  tags    = "postgres"
  #  count   = 3
  #  name    = ["postgres-01", "postgres-02", "postgres-03"]
  #  cores   = 4
  #  memory  = "4096"
  #  drive   = 40
  #  storage = "cache-domains"
  #  node    = ["mothership", "overlord", "vanguard"]
  #  ip      = ["34", "35", "36"]
  #}
  pihole = {
    tags    = "pihole"
    count   = 3
    name    = ["pihole-01", "pihole-02", "pihole-03"]
    cores   = 2
    memory  = "2048"
    drive   = 20
    storage = "local"
    node    = ["mothership", "overlord", "vanguard"]
    ip      = ["41", "42", "43"]
  }
}
