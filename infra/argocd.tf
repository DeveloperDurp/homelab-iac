provider "helm" {
  kubernetes {
    host               = "https://${local.talos.cluster_dns}:6443"
    client_certificate = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-certificate-data"])
    client_key         = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-key-data"])
    insecure           = true
  }
}

provider "kubernetes" {
  host                   = "https://${local.talos.cluster_dns}:6443"
  client_certificate     = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-certificate-data"])
  client_key             = base64decode(yamldecode(module.talos_infra_cluster.kubeconfig).users[0].user["client-key-data"])
  insecure               = true
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

resource "kubernetes_secret" "gitlab_repo_creds" {
  metadata {
    name      = "gitlab-repo-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    "type"     = "git"
    "url"      = "https://gitlab.durp.info/durfy/homelab/gitops.git"
  }
}

resource "kubernetes_manifest" "root_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://gitlab.durp.info/durfy/homelab/gitops.git"
        path           = "infra/apps"
        targetRevision = "HEAD"
      }
      destination = {
        name      = "in-cluster"
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
  depends_on = [helm_release.argocd]
}
