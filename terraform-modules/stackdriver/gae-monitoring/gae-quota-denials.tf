locals {
  quota_denial_metric             = "metric.type=\"appengine.googleapis.com/http/server/quota_denial_count\" resource.type=\"gae_app\""
  quota_denial_threshold          = 0
  quota_denial_threshold_duration = "300s"
}

resource google_monitoring_alert_policy gae-quota-denial-alert {
  provider              = google.target
  project               = var.gae_host_project
  display_name          = "${var.service_name}-quota-denial-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {
    service = var.service_name
  }

  documentation {
    content   = "the ${var.service_name} app has been experiencing quota denials on data sent or received that may be casuing failed responses"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-quota-denials"

    condition_threshold {
      threshold_value = local.quota_denial_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = local.quota_denial_threshold_duration

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
