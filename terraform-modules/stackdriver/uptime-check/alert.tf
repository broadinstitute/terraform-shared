locals {
  uptime_metric  = var.enabled ? "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.uptime_check[0].uptime_check_id}\"" : ""
  latency_metric = var.enabled ? "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.uptime_check[0].uptime_check_id}\"" : ""
}

resource "google_monitoring_alert_policy" "uptime_alert" {
  count                 = var.enabled ? 1 : 0
  provider              = google.target
  project               = var.google_project
  display_name          = "${var.service}-availability"
  combiner              = var.combiner
  notification_channels = var.notification_channels

  documentation {
    content = var.alert_documentation
  }

  conditions {
    display_name = "${var.service}-uptime"

    condition_threshold {
      threshold_value = 1
      comparison      = var.comparison
      duration        = var.duration
      filter          = local.uptime_metric

      aggregations {
        # These values are specific to this metric and should not be adjusted 
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        alignment_period     = "600s"
        group_by_fields      = []
        cross_series_reducer = "REDUCE_COUNT_FALSE"
      }
    }
  }

  conditions {
    display_name = "${var.service}-latency"

    condition_threshold {
      threshold_value = var.latency_threshold
      comparison      = var.comparison
      duration        = var.duration
      filter          = local.latency_metric

      aggregations {
        per_series_aligner   = "ALIGN_MEAN"
        alignment_period     = "60s"
        group_by_fields      = []
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  user_labels = merge(
    var.alert_labels,
    var.revere_label_configuration != null && var.revere_label_configuration.enable_revere_service_labels ? {
      revere-service-name        = var.revere_label_configuration.revere_service_name
      revere-service-environment = var.revere_label_configuration.revere_service_environment
      revere-alert-type          = var.revere_label_configuration.revere_alert_type_uptime
    } : {}
  )
}

