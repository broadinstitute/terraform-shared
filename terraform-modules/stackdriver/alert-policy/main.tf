resource google_monitoring_alert_policy node_resource_alerts {

  display_name = "k8s-node-resource-usage-alert"

  # Valid option are "AND" or "OR"
  combiner = var.condition_combine_method
  project = var.project

  conditions {
    # name to be associated with the condition for display in gcloud
    display_name = "node-cpu-utilization"    

    # condition_absent {
    #   # Specifiy condition behavior if metric data is missing
    # } 

    condition_threshold {
      # Specify circumstances where alert is triggered

      threshold_value = 0.95

      comparison = "COMPARISON_GT"
      duration = "300s"

      # Specify api path of metrics and any resource filters to apply
      filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""

      aggregations {
        # group_by_fields = ["metric.label.\"instance_name\""]
        per_series_aligner = "ALIGN_MEAN" 
        alignment_period = "60s"

      }

    }
  }

  conditions {
    display_name = "node-memory-utilization"

    condition_threshold {
      threshold_value = 0.95

      comparison = "COMPARISON_GT"
      duration = "300s"

      filter = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" resource.type=\"k8s_node\""

      aggregations {
        per_series_aligner = "ALIGN_MEAN"
        alignment_period = "60s"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["resource.labels.node_name"]
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
    content = "A kubernetes node has been utilizizing more resources than expected for an extneded period of time"
    mime_type = "text/markdown"
  }
}