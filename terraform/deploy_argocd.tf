resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.1.3" # Stable version of the Argo CD helm chart
  namespace        = "argocd"
  create_namespace = true    # Tells Terraform to create the 'argocd' namespace automatically

  # Out of the box, GKE Autopilot will assign resources efficiently. 
  # We use ClusterIP because it's a private cluster and we don't want an external LoadBalancer.
  set = [
    {
      name  = "server.service.type"
      value = "ClusterIP"
    }
  ]

  # This prevents Terraform from trying to fight or modify Argo CD later
  lifecycle {
    ignore_changes = all
  }
}