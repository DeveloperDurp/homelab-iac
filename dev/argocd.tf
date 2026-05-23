variable "argocd_token" {
  description = "argocd token"
  type        = string
}

provider "argocd" {
  server_addr = "https://argocd.infra.durp.info"
  auth_token  = var.argocd_token
}

resource "argocd_cluster" "dev_cluster" {
  server = "https://${local.talos.cluster_dns}:6443"
  name   = local.talos.cluster_name

  config {
    bearer_token = data.utils_kubeconfig.dev.token
    tls_client_config {
      ca_data = data.utils_kubeconfig.dev.ca_data
    }
  }

  # Optional: Add labels or annotations
  metadata {
    labels = {
      environment = "development"
      managed-by  = "terraform"
    }
  }
}

# Using the kubeconfig generated in talos.tf
data "utils_kubeconfig" "dev" {
  kubeconfig = output.kubeconfig.kubeconfig_raw
}
