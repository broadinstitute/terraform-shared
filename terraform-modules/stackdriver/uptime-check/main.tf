
resource google_monitoring_uptime_check_config http_check {
  provider = google.target

  display_name = var.check_name
  timeout      = var.check_timeout
  period       = var.check_frequency

  http_check {
    path = var.url_path
    port = var.port
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project
      host       = var.domain_name

      # Used to toggle http vs https, default to http
      use_ssl      = var.https_enabled
      validate_ssl = var.https_enabled
    }
  }
}
