locals {
  response_code_metric = "metric.type=\"appengine.googleapis.com/http/server/response_count\" resource.type=\"gae_app\" resource.label.\"module_id\"=\"import-service\" metric.label.\"response_code\">=\"500\""
}

resource google_monitoring_alert_policy gae-response-code-alert {
  provider = google.target

  display_name          = "${var.service_name}-response-code-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "the ${var.service_name} app has been responding with 500 internal server error status codes for greater than a minute"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-app-500-response"

    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "60s"

      filter = local.response_code_metric

      aggregations {
        per_series_aligner   = var.series_align_method.rate
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.count
        group_by_fields      = [var.group_by_labels.response_code]
      }
    }
  }
}
