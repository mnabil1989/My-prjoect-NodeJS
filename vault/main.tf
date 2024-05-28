variable "vault_image" {
  type = string
  default = "hashicorp/vault:1.10.3"
}

resource "google_container_engine_v1_deployment" "vault" {
  name = "vault"
  metadata {
    namespace = "vault"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vault"
      }
    }

    template {
      metadata {
        labels = {
          app = "vault"
        }
      }

      spec {
        container {
          name  = "vault"
          image = var.vault_image
          ports {
            container_port = 8200
          }
          volume_mounts {
            name      = "vault-storage"
            mount_path = "/vault/data"
          }
        }

        volume {
          name = "vault-storage"
          persistent_volume_claim {
            claim_name = "vault-pvc"
          }
        }
      }
    }
  }
}

resource "google_persistent_volume_claim" "vault-pvc" {
  metadata {
    name = "vault-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

# Configure service for Vault (optional)
resource "google_container_engine_v1_service" "vault-service" {
  name = "vault-service"
  metadata {
    namespace = "vault"
  }

  spec {
    selector = {
      app = "vault"
    }

    ports {
      port        = 8200
      target_port = 8200
    }

    type = "ClusterIP"
  }
}
