locals {
  container_restart_threshold = 0
  container_restart_metric    = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\""
  threshold_duration          = "600s"
}

resource google_monitoring_alert_policy pod_health_alert {
  provider              = google.target
  display_name          = "k8s-container-health-status"
  project               = var.project
  combiner              = local.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "A container has been experiencing frequent restarts for greater than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "container-frequent-restarts"

    condition_threshold {
      threshold_value = local.container_restart_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = local.threshold_duration

      filter = local.container_restart_metric

      aggregations {
        per_series_aligner   = "ALIGN_DELTA"
        alignment_period     = "600s"
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.container_name, var.group_by_labels.pod_name]
      }
    }
  }
}
