
locals {
  current_deployment_replicas_namespace_metric = "metric.type=\"external.googleapis.com/prometheus/kube_deployment_status_replicas_available\" resource.type=\"k8s_container\""
  desired_deployment_replicas_namespace_metric = "metric.type=\"external.googleapis.com/prometheus/kube_deployment_spec_replicas\" resource.type=\"k8s_container\""
  current_desired_replicas_namespace_threshold = 1
}

resource google_monitoring_alert_policy deployment_health {
  provider              = google.target
  display_name          = "k8s-deployment-status-by-namespace"
  project               = var.project
  combiner              = local.condition_combine_method
  enabled               = true
  notification_channels = var.notification_channels
  user_labels = {

  }

  documentation {
    content   = "A deployment in the namespace above has been running fewer pods than specified in deployment spec for an extended period of time"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "current-vs-desired-pods-namespace-deployment"

    condition_threshold {
      threshold_value = local.current_desired_replicas_namespace_threshold
      comparison      = var.threshold_comparison.less_than
      duration        = var.threshold_duration

      filter             = local.current_deployment_replicas_namespace_metric
      denominator_filter = local.desired_deployment_replicas_namespace_metric

      aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.deployment]
        cross_series_reducer = var.reducer_method.sum
      }

      denominator_aggregations {
        per_series_aligner   = var.series_align_method
        alignment_period     = var.alignment_period
        group_by_fields      = [var.group_by_labels.cluster_name, var.group_by_labels.namespace_name, var.group_by_labels.deployment]
        cross_series_reducer = var.reducer_method.sum
      }
    }
  }
}
