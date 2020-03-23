/* 
This resources configures an alert policy which 
Which monitors the nodes in k8s cluster for primary
resource usage ie cpu and memory. An alert will be triggered if any node 
shows unusual behavior
*/

locals {
  # API resource definitions which return desired timeseries for this alerting policy
  node_cpu_metric    = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
  node_memory_metric = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" resource.type=\"k8s_node\""
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

  conditions {
    # name to be associated with the condition for display in gcloud
    display_name = "node-cpu-utilization"

    # condition_absent {
    #   # Specifiy condition behavior if metric data is missing
    # } 

    condition_threshold {

      # Specify circumstances where alert is triggered
      threshold_value = local.node_cpu_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration

      # Specify api path of metrics and any resource filters to apply
      filter = local.node_cpu_metric

      aggregations {

        per_series_aligner = var.series_align_method
        alignment_period   = var.alignment_period
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
        group_by_fields      = [var.group_by_labels.node_name]
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
    content   = "A cluster node has been running with high resource utilization for greater than ${var.threshold_duration}econds"
    mime_type = "text/markdown"
  }
}
