data "google_monitoring_notification_channel" "slack_channel" {
  display_name = var.channel_name
  type         = var.alert_type
}
