locals {
  quota_denial_metric = "metric.type=\"appengine.googleapis.com/http/server/quota_denial_count\" resource.type=\"gae_app\" resource.label.\"module_id\"=\"${var.service_name}\""
}

resource google_monitoring_alert_policy gae-quota-denial-alert {
  provider = google.target

  display_name          = "${var.service_name}-quota-denial-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "the ${var.service_name} app has been experiencing quota denials on data sent or received that may be casuing failed responses"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-quota-denials"

    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "300s"

      filter = local.quota_denial_metric

      aggregations {
        per_series_aligner   = var.series_align_method.rate
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.module_id]
      }
    }
  }
}
