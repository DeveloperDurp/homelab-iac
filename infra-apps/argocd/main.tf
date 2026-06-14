# This will be the new entry point for ArgoCD bootstrapping
# Everything that depends on the live Kubernetes API is now moved here.

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.11.1"

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
