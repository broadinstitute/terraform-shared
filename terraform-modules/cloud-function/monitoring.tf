data "google_monitoring_notification_channel" "monitoring_channel" {
  for_each     = var.monitoring_channel_names
  project      = var.google_project
  display_name = each.value
}

resource "google_monitoring_alert_policy" "alert_policy" {
  count                 = length(var.monitoring_channel_names) > 0 ? 1 : 0
  display_name          = "${google_cloudfunctions_function.function.name}-failed"
  notification_channels = data.google_monitoring_notification_channel.monitoring_channel[*].name
  combiner              = "OR"
  conditions {
    display_name = "crash/error executions for ${google_cloudfunctions_function.function.name}"
    condition_threshold {
      filter     = <<-EOT
        metric.type="cloudfunctions.googleapis.com/function/execution_count"
        resource.type="cloud_function"
        resource.label."function_name"="${google_cloudfunctions_function.function.name}"
        resource.label."project_id"="${var.google_project}"
        metric.label."status"!="ok"
      EOT
      duration   = var.monitoring_failure_trigger_period
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = var.monitoring_failure_trigger_period
        cross_series_reducer = "REDUCE_COUNT"
        per_series_aligner   = "ALIGN_RATE"
      }
      trigger {
        count = var.monitoring_failure_trigger_count
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
      Cloud Function `${google_cloudfunctions_function.function.name}` failures rose above ${var.monitoring_failure_trigger_count} within ${var.monitoring_failure_trigger_period} in ${var.google_project}.
      
      [See logs](https://console.cloud.google.com/functions/details/${google_cloudfunctions_function.function.region}/${google_cloudfunctions_function.function.name}?project=${var.google_project}&tab=logs)
    EOT
  }
  enabled = true
}
