locals {
  response_code_metric = "metric.type=\"appengine.googleapis.com/http/server/response_count\" resource.type=\"gae_app\" metric.label.\"response_code\">=\"500\""
  # Trigger alert if there are any responses with code 5xx
  response_code_threshold          = 0
  response_code_threshold_duration = "60s"
}

resource google_monitoring_alert_policy gae-response-code-alert {
  provider              = google.target
  project               = var.gae_host_project
  display_name          = "${var.service_name}-response-code-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {
    service = var.service_name
  }

  documentation {
    content   = "the ${var.service_name} app has been responding with 500 internal server error status codes for greater than a minute"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-app-500-response"

    condition_threshold {
      threshold_value = local.response_code_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = local.response_code_threshold_duration

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
