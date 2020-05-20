variable "auth_proxy_dns_name" {
  type    = string
  default = "auth-proxy"
}

variable "auth_proxy_dns_project" {
  default = null
}

variable "auth_proxy_dns_zone" {
  type = string
}

locals {
  records = {
    (var.auth_proxy_dns_name) = {
      type    = "A"
      rrdatas = google_compute_global_address.global_ip.address
    }
  }
}
