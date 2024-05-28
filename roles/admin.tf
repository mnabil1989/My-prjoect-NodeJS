resource "google_kubernetes_cluster_role" "admin" {
  name = "admin-role"

  lifecycle_rule {
    verb      = "*"
    api_groups = ["*"]
    resources = ["*"]
  }
}
