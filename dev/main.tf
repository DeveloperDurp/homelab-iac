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
  template       = "tails-Template"
  format         = "raw"
  dnsserver      = "192.168.${local.vlan}.1"
  gateway        = "192.168.${local.vlan}.1"
  vlan           = 10
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
    cluster_vip  = "192.168.10.10"
  }
}
