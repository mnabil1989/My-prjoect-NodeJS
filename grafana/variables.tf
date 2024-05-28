variable "grafana_image" {
  type = string
  default = "grafana/grafana:8.5.1"
}

variable "grafana_persistent_volume_size" {
  type = number
  default = 10
}
