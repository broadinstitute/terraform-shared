resource google_monitoring_uptime_check_ocnfig gae_uptime_check {
  provider     = google.target
  project      = var.workspace_host_project
  display_name = "${var.service_name}-uptime-check"
  timeout      = "30s"
  period       = "60s"

  http_check {
    path = var.uptime_api_path
    port = var.port
    # Used to toggle http vs https, default to http
    use_ssl      = var.https_enabled
    validate_ssl = var.https_enabled
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project
      host       = var.gae_app_domain
    }
  }
}

locals {
  uptime_metric = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"="
}

resource google_monitoring_alert_policy gae-uptime-alert {
  provider = google.target

  display_name          = "${var.service_name}-uptime-alert"
  project               = var.workspace_host_project
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

      filter = "${local.uptime_metric}=\"${gae_uptime_check.uptime_check_id}\""

      aggregations {
        per_series_aligner   = var.serires_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.check_id]
      }
    }
  }
}


