locals {
  response_latency_metric = "metric.type=\"appengine.googleapis.com/http/server/response_latencies\" resource.type=\"gae_app\" resource.label.\"module_id\"=\"import-service\""
}

resource google_monitoring_alert_policy gae-response-latency-alert {
  provider = google.target

  display_name          = "${var.service_name}-response-latency-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "the ${var.service_name} app has been experiencing high response latency for greater than 1 minute"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-app-response-latency"

    condition_threshold {
      threshold_value = 1500
      comparison      = "COMPARISON_GT"
      duration        = "300s"

      filter = local.response_latency_metric

      aggregations {
        per_series_aligner   = var.series_align_method.sum
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.percentile_99
        group_by_fields      = [var.group_by_labels.module_id]
      }
    }
  }
}
