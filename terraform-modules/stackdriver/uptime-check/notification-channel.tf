# # data "google_monitoring_notification_channel" "slack_channel" {
# #   display_name = var.channel_name
# #   type         = var.alert_type
# #   provider     = google.target
# # }
data "vault_generic_secret" "slack_token" {
  path = "secret/suitable/terraform/stackdriver/slack-token"
}

locals {
  is_prod = var.google_project == "broad-dsde-prod" ? true : false
}

data "google_monitoring_notification_channel" "pagerduty" {
  count        = var.enable_pagerduty && local.is_prod ? 1 : 0
  display_name = var.pagerduty_channel
}

resource "google_monitoring_notification_channel" "slack_channels" {
  count = var.enabled ? length(var.channel_names) : 0

  display_name = var.channel_names[count.index]
  type         = "slack"
  project      = var.google_project
  labels = {
    "channel_name" = var.channel_names[count.index]
  }
  sensitive_labels {
    auth_token = data.vault_generic_secret.slack_token.data["key"]
  }
}

# Used for ssl alert
resource "google_monitoring_notification_channel" "ssl_channel" {
  count = var.enabled ? 1 : 0

  display_name = var.ssl_alert_channel
  type         = "slack"
  project      = var.google_project
  labels = {
    "channel_name" = var.ssl_alert_channel
  }
  sensitive_labels {
    auth_token = data.vault_generic_secret.slack_token.data["key"]
  }
}
