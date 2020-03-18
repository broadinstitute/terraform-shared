/*
Creates an alert policy which monitors the ratio of
pods currently running in a cluster to the max number of pods
a cluster can support.
It will trigger the alert if current pods running are above 95% max capacity for number of pods 
*/


resource google_monitoring_alert_policy cluster_health_check {

  provider              = google.target
  display_name          = "k8s-cluster-pod-capacity"
  project               = var.project
  combiner              = var.condition_combine_method
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
      threshold_value = var.cluster_pod_capacity_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.cluster_threshold_duration

      denominator_filter = var.cluster_pod_capacity_metric

      denominator_aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.cluster_name]
        cross_series_reducer = var.reducer_method.sum
      }
      filter = var.cluster_pod_running_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.cluster_name]
        cross_series_reducer = var.reducer_method.sum
      }
    }
  }
}
