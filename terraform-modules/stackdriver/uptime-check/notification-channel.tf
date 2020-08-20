# # data "google_monitoring_notification_channel" "slack_channel" {
# #   display_name = var.channel_name
# #   type         = var.alert_type
# #   provider     = google.target
# # }
data "vault_generic_secret" "slack_token" {
  path = "secret/suitable/terraform/stackdriver/slack-token"
}

resource "google_monitoring_notification_channel" "slack_channel" {
  type    = "slack"
  project = var.google_project
  labels = {
    "channel_name" = var.channel_name
  }
  sensitive_labels {
    auth_token = data.vault_generic_secret.slack_token.data["key"]
  }
}


