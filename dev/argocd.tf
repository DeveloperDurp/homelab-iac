variable "argocd_token" {
  description = "argocd token"
  type        = string
}

provider "argocd" {
  server_addr = "argocd.infra.durp.info:443"
  username    = "admin"
  password    = var.argocd_token
  insecure    = true
}

locals {
  kubeconfig = yamldecode(module.talos_dev_cluster.kubeconfig)
}

resource "argocd_cluster" "dev_cluster" {
  server = "https://${local.talos.cluster_dns}:6443"
  name   = local.talos.cluster_name

  config {
    tls_client_config {
      ca_data   = base64decode(local.kubeconfig.clusters[0].cluster["certificate-authority-data"])
      cert_data = base64decode(local.kubeconfig.users[0].user["client-certificate-data"])
      key_data  = base64decode(local.kubeconfig.users[0].user["client-key-data"])
    }
  }

  metadata {
    labels = {
      environment = "development"
      managed-by  = "terraform"
    }
  }
}
