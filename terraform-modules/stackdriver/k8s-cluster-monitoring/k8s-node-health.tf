/*
This resource configures an alert policy which monitors nodes
in a k8s cluster for many aspects of general node health.
This module requires that your cluster is configured to run prometheus and kube-state-metrics
and exports them to stackdriver.

This resource monitors the following aspects of node health and will trigger an alert
if any of them are in failing state:

Corrupt Docker Overlay
Disk Pressure
Memory Pressure
Frequent Container Restarts
Frequent Docker Restarts
Frequent Kubelet Restarts
Kernel Deadlock
Network Unavailable
PID Pressure

*/

locals {
  node_health_metric = "metric.type=\"external.googleapis.com/prometheus/kube_node_status_condition\" resource.type=\"k8s_container\" metric.label.\"condition\"!=\"Ready\" metric.label.\"status\"!=\"false\""
  # Triggers alert if any of the node health states are failing
  node_health_check_threshold = 0
}

resource google_monitoring_alert_policy node_health_check {

  provider              = google.target
  count                 = var.enable_prometheus_filter ? 1 : 0
  display_name          = "k8s-node-health-status"
  project               = var.project
  combiner              = local.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "A cluster node is failing a kube state health check, view metric: external.googleapis.com/prometheus/kube_node_status_condition for more details"
    mime_type = "text/markdown"
  }

  conditions {

    display_name = "k8s-node-health-check"

    condition_threshold {

      threshold_value = local.node_health_check_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration
      filter          = local.node_health_metric

      aggregations {

        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.node_health_condition]
        cross_series_reducer = var.reducer_method.sum
      }
    }
  }
}
