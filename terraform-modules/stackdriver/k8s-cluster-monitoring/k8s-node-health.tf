resource google_monitoring_alert_policy node_health_check {

  provider              = google.target
  display_name          = "k8s-node-health-status"
  project               = var.project
  combiner              = var.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {

  }

  documentation {
    content   = "A node in the ${var.cluster_name} cluster is failing a kube state health check, view metric: external.googleapis.com/prometheus/kube_node_status_condition for more details"
    mime_type = "text/markdown"
  }

  conditions {

    display_name = "k8s-node-health-check"

    condition_threshold {

      threshold_value = var.node_health_check_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.node_threshold_duration
      filter          = var.node_health_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.node_health_condition]
        cross_series_reducer = var.reducer_method.sum
      }
    }
  }
}
