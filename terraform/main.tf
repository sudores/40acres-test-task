resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [ ]

  depends_on = [kubernetes_namespace.argocd]
  provisioner "local-exec" {
      command = "kubectl apply -n argocd -f ./assets/argocd-root-app.yaml"
  }
}

