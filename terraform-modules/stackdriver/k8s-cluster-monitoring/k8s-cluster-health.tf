/*
Creates an alert policy which monitors the ratio of
pods currently running in a cluster to the max number of pods
a cluster can support.
It will trigger the alert if current pods running are above 95% max capacity for number of pods 
*/

locals {
  cluster_pod_capacity_metric = "metric.type=\"external.googleapis.com/prometheus/kube_node_status_capacity_pods\" resource.type=\"k8s_container\""
  cluster_pod_running_metric  = "metric.type=\"external.googleapis.com/prometheus/kube_pod_status_phase\" resource.type=\"k8s_container\" metric.label.\"phase\"=\"Running\""
  # Indicates ratio of number of currently running pods to max number of pods cluster can support
  cluster_pod_capacity_threshold = 0.95
}

resource google_monitoring_alert_policy cluster_health_check {

  provider              = google.target
  display_name          = "k8s-cluster-pod-capacity"
  project               = var.project
  combiner              = local.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {

  }

  documentation {
    content   = "A cluster under the ${var.project} project is running a number of pods above the maximum threshold of 630 pods"
    mime_type = "text/markdown"
  }

  conditions {

    display_name = "cluster-wide-pod-capacity-utilization"

    condition_threshold {
      threshold_value = local.cluster_pod_capacity_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration

      denominator_filter = local.cluster_pod_capacity_metric

      denominator_aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.cluster_name]
        cross_series_reducer = var.reducer_method.sum
      }
      filter = local.cluster_pod_running_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.cluster_name]
        cross_series_reducer = var.reducer_method.sum
      }
    }
  }
}
