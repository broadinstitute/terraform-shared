locals {
  cpu_usage_metric    = "metric.type=\"appengine.googleapis.com/system/cpu/usage\" resource.type=\"gae_app\""
  memory_usage_metric = "metric.type=\"appengine.googleapis.com/system/memory/usage\" resource.type=\"gae_app\""
  # Unit is megacycles
  cpu_usage_threshold = 10000
  # Unit is bytes 
  memory_usage_threshold            = 512000000
  resource_usage_threshold_duration = "300s"
}

resource google_monitoring_alert_policy gae-resource-usage-alert {
  provider              = google.target
  project               = var.gae_host_project
  display_name          = "${var.service_name}-resource-usage-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {
    service = var.service_name
  }

  documentation {
    content   = "the ${var.service_name} app has been experiencing unusually high resource utilization for greater than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "gae-cpu-usage"

    condition_threshold {
      threshold_value = local.cpu_usage_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = local.resource_usage_threshold_duration

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
      threshold_value = local.memory_usage_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = local.resource_usage_threshold_duration

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
