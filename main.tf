# Configure GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Read variables from a separate file
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

# VPC network configuration
resource "google_compute_network" "vpc" {
  name = "my-vpc"
  auto_create_subnetworks = true
}

# Firewall rule for cluster communication
resource "google_compute_firewall" "cluster-internal" {
  name    = "allow-cluster-internal"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags  = ["cluster-internal"]
}

# Define a reusable cluster module
module "gke_cluster" {
  source  = "./modules/gke_cluster"

  # Inputs for each cluster environment (dev, test, prod)
  cluster_name = var.cluster_name
  initial_node_count = var.initial_node_count
  cluster_admin_password = var.cluster_admin_password

  # Optional: Define RBAC bindings within the module
  # enable_rbac_bindings = true
}

# Example usage for dev, test, and prod clusters (replace with actual names)
data "null_data_source" "cluster_names" {
  count = 3
}

variable "cluster_name" {
  type = string
  description = "Name of the GKE cluster"
}

variable "initial_node_count" {
  type = number
  description = "Initial node count for the cluster"
}

variable "cluster_admin_password" {
  type = string
  sensitive = true
  description = "Admin password for the GKE cluster"
}

resource "google_compute_address" "cluster_ip" {
  count = data.null_data_source.cluster_names.count

  name = "cluster-ip-${data.null_data_source.cluster_names.count.index}"

  network = google_compute_network.vpc.name
}

output "cluster_ips" {
  value = google_compute_address.cluster_ip.*.address
  description = "IP addresses of the GKE clusters"
}
