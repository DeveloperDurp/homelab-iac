# This will be the new entry point for ArgoCD bootstrapping
# Everything that depends on the live Kubernetes API is now moved here.

terraform {
  required_providers {
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

provider "helm" {
  kubernetes {
    host                   = "https://${local.talos.cluster_dns}:6443"
    cluster_ca_certificate = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).clusters[0].cluster["certificate-authority-data"])
    client_certificate     = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-certificate-data"])
    client_key             = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-key-data"])
    insecure               = true
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.7.11"

  lifecycle {
    ignore_changes = [version]
  }

  values = [
    yamlencode({
      server = {
        ingress = {
          enabled = true
          hosts   = ["argocd.infra.durp.loc"]
        }
      }
    })
  ]
}
