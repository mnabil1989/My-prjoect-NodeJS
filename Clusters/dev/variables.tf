variable "cluster_name" {
  type = string
}

variable "google_region" {
  type = string
}

variable "initial_node_count" {
  type = number
}

variable "cluster_admin_password" {
  type = string
  sensitive = true
}
