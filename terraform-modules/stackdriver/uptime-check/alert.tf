locals {
  uptime_metric = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.uptime_check[0].uptime_check_id}\""
}

resource "google_monitoring_alert_policy" "uptime_alert" {
  count    = var.enabled ? 1 : 0
  provider = google.target

  display_name          = "${var.service}-unavailable"
  combiner              = "OR"
  notification_channels = []

  conditions {
    display_name = "${var.service}-uptime"

    condition_threshold {
      threshold_value = 1
      comparison      = "COMPARISON_GT"
      duration        = "300s"
      filter          = local.uptime_metric

      aggregations {
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        alignment_period     = "600s"
        group_by_fields      = []
        cross_series_reducer = "REDUCE_COUNT_FALSE"
      }
    }
  }
}
