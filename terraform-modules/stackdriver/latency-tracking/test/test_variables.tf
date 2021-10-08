# This file just contains stubs, necessary for test.tf to pass validation

variable "enable" {
  default = true
}

variable "allow_latency_tracking" {
  default = true
}

variable "google_project" {
  default = "broad-dsde-dev"
}

variable "revere_label_configuration" {
  default = {
    enable_revere_service_labels = true
    revere_service_name          = "example-service"
    revere_service_environment   = "dev"
    revere_alert_type_latency    = "degraded-performance"
  }
}

locals {
  fqdn                               = "example.com"
  critical_notification_channels     = ["some-channel"]
  non_critical_notification_channels = ["some-other-channel"]
}
