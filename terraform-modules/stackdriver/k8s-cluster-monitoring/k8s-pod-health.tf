locals {
  pod_failed_shedule_threshold = 0
  pod_failed_schedule_metric   = "metric.type=\"external.googleapis.com/prometheus/kube_pod_status_phase\" resource.type=\"k8s_container\" metric.label.\"phase\"=\"Failed\""
}

resource google_monitoring_alert_policy pod_health_alert {
  provider              = google.target
  display_name          = "k8s-pod-health-status"
  project               = var.project
  combiner              = local.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {

  }

  documentation {
    content   = "1 or more pods have failed to be scheduled for more than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "pod-status-failed-scheduling"

    condition_threshold {
      threshold_value = local.pod_failed_shedule_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration

      filter = local.pod_failed_schedule_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.pod_name]
      }
    }
  }
}
