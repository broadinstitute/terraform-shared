locals {
  dos_intercept_metric = "metric.type=\"appengine.googleapis.com/http/server/dos_intercept_count\" resource.type=\"gae_app\" resource.label.\"module_id\"=\"import-service\""
}

resource google_monitoring_alert_policy gae-dos-intercept-alert {
  provider = google.target

  display_name          = "${var.service_name}-dos-intercept-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "the ${var.service_name} app has been experiencing DOS intercepts for more than one minute. This may affect application availability"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-dos-intercepts"

    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "60s"

      filter = local.dos_intercept_metric

      aggregations {
        per_series_aligner   = var.series_align_method.rate
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.module_id]
      }
    }
  }
}
