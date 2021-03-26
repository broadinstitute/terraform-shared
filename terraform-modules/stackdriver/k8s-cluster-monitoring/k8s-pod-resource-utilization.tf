locals {
  memory_limit_threshold       = 0.95
  volume_util_threshold        = 0.95
  cpu_limit_util_threshold     = 0.95
  pod_memory_limit_util_metric = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" metric.label.\"memory_type\"=\"non-evictable\" resource.label.\"namespace_name\"!=\"kube-system\""
  volume_util_metric           = "metric.type=\"kubernetes.io/pod/volume/utilization\" resource.type=\"k8s_pod\" resource.label.\"namespace_name\"!=\"kube-system\""
  cpu_limit_util_metric        = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"!=\"kube-system\""
}

resource google_monitoring_alert_policy pod_memory_util {
  provider              = google.target
  display_name          = "k8s-pod-resource-utilization"
  project               = var.project
  combiner              = local.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels

  documentation {
    content   = "A pod has been requesting greater than 95% of a resource limit for longer than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "pod-memory-limit-utilization"

    condition_threshold {
      threshold_value = local.memory_limit_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration

      filter = local.pod_memory_limit_util_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.pod_name]
      }
    }
  }

  conditions {
    display_name = "pod-volume-utilization"

    condition_threshold {
      threshold_value = local.volume_util_threshold
      comparison      = var.threshold_comparison.greater_than
      duration        = var.threshold_duration

      filter = local.volume_util_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.pod_name, var.group_by_labels.volume_name]
      }
    }
  }

  conditions {
    display_name = "pod-cpu-limit-utilization"

    condition_threshold {
      threshold_value = local.cpu_limit_util_threshold
      duration        = var.threshold_duration
      comparison      = var.threshold_comparison.greater_than

      filter = local.cpu_limit_util_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        cross_series_reducer = var.reducer_method.sum
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.pod_name, var.group_by_labels.container_name]
      }
    }
  }
}
