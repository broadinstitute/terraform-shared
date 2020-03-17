resource google_monitoring_alert_policy node_resource_alerts {

  provider     = google.target
  display_name = "k8s-node-resource-usage-alert"

  # Valid option are "AND" or "OR"
  combiner = var.condition_combine_method
  project  = var.project

  conditions {
    # name to be associated with the condition for display in gcloud
    display_name = "node-cpu-utilization"

    # condition_absent {
    #   # Specifiy condition behavior if metric data is missing
    # } 

    condition_threshold {

      # Specify circumstances where alert is triggered
      threshold_value = var.node_cpu_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.node_threshold_duration

      # Specify api path of metrics and any resource filters to apply
      filter = var.node_cpu_metric

      aggregations {

        per_series_aligner = var.series_align_method
        alignment_period   = var.alignment_period
      }
    }
  }

  conditions {
    display_name = "node-memory-utilization"

    condition_threshold {

      threshold_value = var.node_memory_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.node_threshold_duration

      filter = var.node_memory_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = ["${var.group_by_labels.node_name}"]
      }
    }
  }

  enabled = true

  # An array of previously created notification_channel objects that should be alerted if a condition fails
  notification_channels = var.notification_channels
  user_labels = {
    # Key value pairs used for organizing alerting policies ie. by application
  }

  documentation {
    # Information to be displayed in a dashboard that provides more context for the alert
    content   = "A node in the ${var.cluster_name} cluster has been running with high resource utilization for greater than ${var.node_threshold_duration}econds"
    mime_type = "text/markdown"
  }
}
