variable "cluster_name" {
  type = string
}

resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.google_region
  initial_node_count = 2
  # ... other cluster configurations

  master_auth {
    username = "admin"
    password = var.cluster_admin_password
  }

  node_pool {
    name      = "default-pool"
    machine_type = "e2-micro"
    node_count = 3
  }
}

# RBAC configuration (example using a separate role definition)
resource "google_kubernetes_cluster_role_binding" "cluster_admin_binding" {
  cluster = google_container_cluster.cluster.name
  role    = google_kubernetes_cluster_role.admin.name  # Reference role from roles/
  subjects = [
    {
      kind = "ServiceAccount"
      name = "default"
      namespace = ""
    },
  ]
}
