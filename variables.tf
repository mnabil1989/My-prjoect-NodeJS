variable "project_id" {
  type = string
  description = "Your GCP project ID"
}

variable "region" {
  type = string
  description = "Region for your GKE clusters (e.g., us-central1)"
}

# VPC network configuration
variable "vpc_name" {
  type = string
  default = "my-vpc"
  description = "Name of the VPC network"
}

# Firewall rule
variable "firewall_rule_name" {
  type = string
  default = "allow-cluster-internal"
  description = "Name of the firewall rule for cluster communication"
}

# GKE cluster configuration (per environment)
variable "cluster_names" {
  type = list(string)
  description = "List of GKE cluster names (dev, test, prod)"
}

variable "initial_node_count" {
  type = map(number)
  description = "Map of initial node counts for each cluster (key: cluster name, value: node count)"
}

variable "cluster_admin_password" {
  type = map(string)
  sensitive = true
  description = "Map of admin passwords for each cluster (key: cluster name, value: password)"
}

# RBAC configuration (optional)
variable "enable_rbac_bindings" {
  type = bool
  default = false
  description = "Enable RBAC bindings within the GKE cluster module"
}

# Node.js application deployment (Helm chart)
variable "helm_chart_name" {
  type = string
  description = "Name of your Helm chart for the Node.js application"
}

variable "helm_chart_repo" {
  type = string
  description = "Helm chart repository URL (optional)"
}

variable "helm_chart_values_files" {
  type = list(string)
  description = "List of Helm chart values files for your application"
}

# ArgoCD configuration
variable "argocd_project" {
  type = string
  description = "ArgoCD project name for your applications"
}

variable "argocd_repo_url" {
  type = string
  description = "URL of your Git repository containing Helm charts"
}

# Prometheus and Grafana configuration (optional)
variable "prometheus_operator_image" {
  type = string
  default = "prom/prometheus-operator:v2.33.0"
  description = "Image for the Prometheus Operator deployment"
}

variable "grafana_image" {
  type = string
  default = "grafana/grafana:8.5.1"
  description = "Image for the Grafana deployment"
}

variable "grafana_persistent_volume_size" {
  type = number
  default = 10
  description = "Size (Gi) of the persistent volume for Grafana storage"
}
