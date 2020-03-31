resource google_monitoring_uptime_check_config gae_uptime_check {
  provider     = google.target
  display_name = "${var.service_name}-uptime-check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path = var.gae_api_path
    port = var.https_enabled ? "443" : "80"
    # Used to toggle http vs https, default to http
    use_ssl      = var.https_enabled
    validate_ssl = var.https_enabled
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gae_host_project
      host       = var.gae_domain
    }
  }
}

locals {
  uptime_metric = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" resource.label.\"host\"=\"${var.gae_domain}\""
}

resource google_monitoring_alert_policy gae-uptime-alert {
  provider = google.target

  display_name          = "${var.service_name}-uptime-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "An uptime check on the import-service GAE app has been failing for more than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-app-uptime-check-passed"

    condition_threshold {
      threshold_value = 1
      comparison      = "COMPARISON_LT"
      duration        = "300s"

      filter = local.uptime_metric

      aggregations {
        per_series_aligner = var.series_align_method.count_true
        alignment_period   = var.alignment_period
      }
    }
  }
}


