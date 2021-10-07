resource "google_monitoring_alert_policy" "latency_alert" {
  for_each = {
    for name, config in local.final_computed_endpoints : name => config
    if config.enable_alerts
  }

  project      = var.google_project
  display_name = "${var.service}-${var.environment}-${each.key}-endpoint-latency-alert"
  combiner     = "OR"

  documentation {
    content   = <<-EOT
      Latency for the *${var.service} ${each.key}* endpoint *in ${var.environment}* matched by
      `${each.value.computed_regex}` exceeded ${each.value.alert_threshold_milliseconds}ms
      for the ${each.value.alert_rolling_window_percentile}th percentile over
      ${each.value.alert_rolling_window_minutes} minutes
    EOT
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "${var.service}-${var.environment}-${each.key}-endpoint-latency-alert-condition"
    condition_threshold {
      filter = "resource.type = \"l7_lb_rule\" AND metric.type = \"logging.googleapis.com/user/${google_logging_metric.latency_metric[each.key].name}\""
      aggregations {
        alignment_period     = "${floor(each.value.alert_rolling_window_minutes * 60)}s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_PERCENTILE_${each.value.alert_rolling_window_percentile}"
      }
      comparison = "COMPARISON_GT"
      duration   = "${floor(each.value.alert_retest_window_minutes * 60)}s"
      trigger {
        count = 1
      }
      threshold_value = each.value.alert_threshold_milliseconds / 1000
    }
  }

  notification_channels = each.value.alert_notification_channels

  user_labels = each.value.enable_revere_service_labels ? {
    revere-service-name        = each.value.revere_service_name
    revere-service-environment = each.value.revere_service_environment
    revere-alert-type          = each.value.revere_alert_type_latency
  } : null
}
