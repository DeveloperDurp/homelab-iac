# This will be the new entry point for ArgoCD bootstrapping
# Everything that depends on the live Kubernetes API is now moved here.

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
