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
      ca_data   = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.ca_certificate
      cert_data = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.client_certificate
      key_data  = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.client_key
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
