locals {
  cpu_usage_metric    = "metric.type=\"appengine.googleapis.com/system/cpu/usage\" resource.type=\"gae_app\" resource.label.\"module_id\"=\"${var.service_name}\""
  memory_usage_metric = "metric.type=\"appengine.googleapis.com/system/memory/usage\" resource.type=\"gae_app\" resource.label.\"module_id\"=\"${var.service_name}\""
}

resource google_monitoring_alert_policy gae-resource-usage-alert {
  provider = google.target

  display_name          = "${var.service_name}-resource-usage-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "the ${var.service_name} app has been experiencing unusually high resource utilization for greater than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-cpu-usage"

    condition_threshold {
      threshold_value = 10000
      comparison      = "COMPARISON_GT"
      duration        = "300s"

      filter = local.cpu_usage_metric

      aggregations {
        per_series_aligner   = var.series_align_method.mean
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.module_id]
      }
    }
  }

  conditions {
    display_name = "gae_memory_usage"

    condition_threshold {
      threshold_value = 512000000
      comparison      = "COMPARISON_GT"
      duration        = "300s"

      filter = local.memory_usage_metric

      aggregations {
        per_series_aligner   = var.series_align_method.mean
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.module_id]
      }
    }
  }
}
