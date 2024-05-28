output "cluster_ips" {
  value = google_compute_address.cluster_ip.*.address
  description = "IP addresses of the GKE clusters"
}

output "cluster_endpoints" {
  value = {
    for cluster in google_container_engine_v1_cluster.gke_cluster : cluster.endpoint
  }
  description = "Endpoint URLs for each GKE cluster (key: cluster name, value: endpoint URL)"
}

# Optional outputs for ArgoCD and Grafana (if deployed using Terraform)
output "argocd_url" {
  value = join("", [
    format("https://", var.argocd_service_name),
    ".", google_compute_address.argocd_ip.address,
    ":", var.argocd_service_port
  ])
  description = "ArgoCD service URL (if deployed using Terraform)"
  depends_on = [ google_compute_address.argocd_ip ]
}

output "grafana_url" {
  value = join("", [
    format("http://", var.grafana_service_name),
    ".", google_compute_address.grafana_ip.address,
    ":", var.grafana_service_port
  ])
  description = "Grafana service URL (if deployed using Terraform)"
  depends_on = [ google_compute_address.grafana_ip ]
}
