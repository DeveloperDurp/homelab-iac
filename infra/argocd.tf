provider "helm" {
  kubernetes {
    host                   = "https://${local.talos.cluster_dns}:6443"
    cluster_ca_certificate = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).clusters[0].cluster["certificate-authority-data"])
    client_certificate     = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-certificate-data"])
    client_key             = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-key-data"])
  }
}

provider "kubernetes" {
  host                   = "https://${local.talos.cluster_dns}:6443"
  cluster_ca_certificate = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).clusters[0].cluster["certificate-authority-data"])
  client_certificate     = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-certificate-data"])
  client_key             = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-key-data"])
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

resource "kubernetes_manifest" "argocd_root" {
  depends_on = [helm_release.argocd]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://gitlab.durp.info/durfy/homelab/gitops.git"
        targetRevision = "main"
        path           = "infra/argocd"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}
