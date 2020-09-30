
locals {
  # API resource definitions which return desired timeseries for this alerting policy
  node_cpu_metric    = "metric.type=\"kubernetes.io/node/cpu/allocatable_utilization\" resource.type=\"k8s_node\" "
  node_memory_metric = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" resource.type=\"k8s_node\" metric.label.\"memory_type\"=\"non-evictable\""
  # Logic need to triggr the alert when there are multiple conditions for a policy
  condition_combine_method = "OR"
  # Thresholds the metrics must violate to trigger alert, both indicate percentages
  node_cpu_threshold    = 0.95
  node_memory_threshold = 0.95
}

resource google_monitoring_alert_policy node_resource_alerts {

  provider     = google.target
  display_name = "k8s-node-resource-usage"

  # Valid option are "AND" or "OR"
  combiner = local.condition_combine_method
  project  = var.project
  enabled  = true
  # An array of previously created notification_channel objects that should be alerted if a condition fails
  notification_channels = var.notification_channels

  documentation {
    content   = "A cluster node has been running with high resource utilization for greater than ${var.threshold_duration}econds"
    mime_type = "text/markdown"
  }
  conditions {

    display_name = "node-cpu-utilization"
    condition_threshold {

      # Specify circumstances where alert is triggered
      threshold_value = local.node_cpu_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration

      # Specify api path of metrics and any resource filters to apply
      filter = local.node_cpu_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.node_name]
      }
    }
  }

  conditions {
    display_name = "node-memory-utilization"

    # Variables for creating alerting metrics are used for readability
    # as many of them contain long monitoring API strings. See variables.tf for more details
    condition_threshold {

      threshold_value = local.node_memory_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration
      filter          = local.node_memory_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.node_name]
      }
    }
  }
}
