variable "grafana_image" {
  type = string
  default = "grafana/grafana:8.5.1"
}

variable "grafana_persistent_volume_size" {
  type = number
  default = 10
}

resource "google_container_engine_v1_deployment" "grafana" {
  name = "grafana"
  metadata {
    namespace = "monitoring"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        container {
          name = "grafana"
          image = var.grafana_image
          ports {
            container_port = 3020
          }
          volume_mounts {
            name      = "grafana-pvc"
            mount_path = "/var/lib/grafana"
          }
        }

        volume {
          name = "grafana-pvc"
          persistent_volume_claim {
            claim_name = "grafana-pvc"
          }
        }
      }
    }
  }
}

resource "google_persistent_volume_claim" "grafana-pvc" {
  metadata {
    name = "grafana-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.grafana_persistent_volume_size + "Gi"
      }
    }
  }
}

# Configure service for Grafana (optional)
resource "google_container_engine_v1_service" "grafana-service" {
  name = "grafana-service"
  metadata {
    namespace = "monitoring"
  }

  spec {
    selector = {
      app = "grafana"
    }

    ports {
      port        = 3020
      target_port = 3020
    }

    type = "LoadBalancer"
  }
}
