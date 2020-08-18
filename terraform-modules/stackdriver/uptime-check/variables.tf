#
# General Vars
#

variable "enabled" {
  type        = bool
  description = "enable flag for uptime check module "
}

variable "google_project" {
  type        = string
  description = "Google project in which to create the uptime check and notification channels"
}

variable "timeout" {
  type        = string
  description = "The number of seconds before the check will automatically fail after not receiving a response"
  default     = "10s"
}

variable "service" {
  type        = string
  description = "The name of the service uptime check will monitor"
}

locals {
  check_name = "${var.service}-uptime"
  port       = var.https_enabled ? "443" : "80"
}

#
# Uptime Check Configuration Vars
# 
variable "path" {
  type        = string
  description = "The URI path to the service's status endpoint"
  default     = "/status"
}

variable "https_enabled" {
  type        = bool
  description = "Flag to enable tls for the uptime check"
  default     = true
}

variable "resource_type" {
  type        = string
  description = "The GCP resource type that the uptime check will monitor. Defaults to checking a fqdn"
  default     = "uptime_url"
}

variable "fqdn" {
  type        = string
  description = "The fully qualified domain name to be used by the uptime check"
}

#
# Notification Channel Vars
#

variable "alert_type" {
  type        = string
  description = "The platform an alert will be sent to if the uptime check fails ie: slack, pagerduty etc"
  default     = "slack"
}

variable "channel_name" {
  type        = string
  description = "The slack channel the alert should fire to"
  default     = ""
}

# Metric vars

variable "combiner" {
  type        = string
  description = "Logical operator applied to conditions associated with an alert. Default behavior is to alert if any condition triggers"
  default     = "OR"
}

variable "comparison" {
  type        = string
  description = "Comparison between a threshold value and current time series value that determines if an alert should fire. Valid inputs are COMPARISON_GT and COMPARISON_LT. Default behavior is to trigger alert if current value is above a threshold"
  default     = "COMPARISON_GT"
}

variable "duration" {
  type        = string
  description = "Amount of time a series must violate a theshold before an alert triggers. Default is to trigger alert after 5 minutes violating a threshold"
  default     = "300s"
}
