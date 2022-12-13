resource "google_monitoring_uptime_check_config" "uptime_check" {
  count        = var.enabled ? 1 : 0
  provider     = google.target
  display_name = local.check_name
  project      = var.google_project
  timeout      = var.timeout

  http_check {
    path         = var.path
    port         = local.port
    use_ssl      = var.https_enabled
    validate_ssl = local.validate_ssl
  }

  monitored_resource {
    type = var.resource_type
    labels = {
      project_id = var.google_project
      host       = var.fqdn
    }
  }
}

locals {
  validate_ssl = var.validate_ssl == false ? var.validate_ssl : var.https_enabled
}
