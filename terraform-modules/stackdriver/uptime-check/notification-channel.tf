resource "google_monitoring_notification_channel" "alert_channel" {
  count    = var.enabled ? 1 : 0
  provider = google.target
  type     = var.alert_type
  labels = {
    "channel_name" = "#sd-alert-testing"
  }

}
