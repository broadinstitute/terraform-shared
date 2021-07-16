data "google_monitoring_notification_channel" "monitoring_channel" {
  for_each     = var.monitoring_channel_names
  project      = var.google_project
  display_name = each.key
}

data "google_project" "project_numeric_id" {
  project_id = var.google_project
}

resource "google_monitoring_alert_policy" "alert_policy" {
  count                 = length(var.monitoring_channel_names) > 0 ? 1 : 0
  display_name          = "${google_cloudfunctions_function.function.name}-failed"
  notification_channels = [for channel in data.google_monitoring_notification_channel.monitoring_channel : channel.name]
  combiner              = "OR"
  conditions {
    display_name = "failed executions for ${google_cloudfunctions_function.function.name}"
    condition_monitoring_query_language {
      query = <<-EOT
        fetch cloud_function
        | metric 'cloudfunctions.googleapis.com/function/execution_count'
        | filter
            resource.project_id == '${data.google_project.project_numeric_id.number}'
            && (resource.function_name == '${google_cloudfunctions_function.function.name}')
            && (${local.monitoring_failure_statuses_filter})
        | align rate(${var.monitoring_failure_trigger_period})
        | every ${var.monitoring_failure_trigger_period}
        | group_by [], [row_count: row_count()]
        | condition row_count > 0 '1'
      EOT
      duration   = var.monitoring_failure_trigger_period
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
