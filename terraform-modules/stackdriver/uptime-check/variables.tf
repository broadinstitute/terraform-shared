#
# General Vars
#

variable "enabled" {
  type        = bool
  description = "enable flag for uptime check module"
  default     = true
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

variable "notification_channels" {
  type        = list(string)
  description = "List of google notification channel ids that alerts will be sent to"
  default     = []
}

variable "alert_labels" {
  type = map(string)
  description = "Extra user labels to apply to the alert policy"
  default = {}
}

locals {
  check_name = "${var.service}-uptime"
  port       = var.https_enabled ? "443" : "80"
}

variable "enable_revere_service_labels" {
  type = bool
  default = false
  description = <<-EOT
    Whether to enable Revere's labeling scheme that allows it to
    programmatically understand notifications triggered by this
    alert policy.

    More information on Revere's label usage available
    [here](https://github.com/broadinstitute/revere/blob/main/docs/gcp_alert_policy_labels.md).
  EOT
}

variable "revere_service_name" {
  type = string
  default = null
  description = <<-EOT
    Override the name of the service this alert monitors as understood by
    [Revere](https://github.com/broadinstitute/revere).

    By default, uses all but the last part of `var.service` (splitting on hyphens).
  EOT
}

variable "revere_service_environment" {
  type = string
  default = null
  description = <<-EOT
    Override the environment of the service this alert monitors as understood by
    [Revere](https://github.com/broadinstitute/revere).

    By default, uses the last part of `var.service` (splitting on hyphens).
  EOT
}

variable "revere_service_degredation" {
  type = string
  default = "uptime"
  description = <<-EOT
    Override what is degraded upon this alert firing as understood by
    [Revere](https://github.com/broadinstitute/revere).
  EOT
}

locals {
  split_service_name = split("-", var.service)
  last_service_name_chunk = locals.split_service_name[max(0, length(local.split_service_name) - 1)]
  all_but_last_service_name_chunk = join("-", slice(local.split_service_name, 0, max(0, length(split_service_name) - 1)))
  revere_service_labels = {
    revere-service-name = var.revere_service_name == null ? local.all_but_last_service_name_chunk : var.revere_service_name
    revere-service-environment = var.revere_service_environment == null ? local.last_service_name_chunk : var.revere_service_environment
    revere-service-degredation = var.revere_service_degredation
  }
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

variable "latency_threshold" {
  type        = string
  description = "Latency in ms that must be exceeded for 5 minutes to trigger the alert"
  default     = "2500"
}

variable "alert_documentation" {
  type        = string
  description = "documentation to display in alert messages"
  default     = ""
}
