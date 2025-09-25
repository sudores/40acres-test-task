resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.5.6"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          hostname         = "argo.gzttk.loc"
          annotations = {
            "kubernetes.io/ingress.class" = "nginx"
          }
          tls       = [] # For Minikube testing, disable TLS
          extraArgs = ["--insecure"]
          params = {
            "server.insecure" = true
          }
        }
        service = {
          type = "ClusterIP" # optional; ingress will handle exposure
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f ./assets/argocd-root-app.yaml"
  }
}

