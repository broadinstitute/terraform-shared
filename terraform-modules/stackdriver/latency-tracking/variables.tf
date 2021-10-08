#
# General Vars
#

variable "enabled" {
  type        = bool
  description = "Whether this module is enabled."
  default     = true
}

variable "google_project" {
  type        = string
  description = "Google project containing the load balancers with latency to track."
}

variable "service" {
  type        = string
  description = "The name of the service to track, used for dashboard/metric/alert names."
}

variable "environment" {
  type        = string
  description = "The environment the service being tracked is in, used for dashboard/metric/alert names."
}

variable "resource_creation_delay_seconds" {
  type        = number
  default     = 3
  description = <<-EOT
    Number of seconds to wait between creation of metrics/alerts and alerts/dashboard. Set to 0 to disable.

    This is a hack! It is necessary because it apparently takes a split second **after** TF believes resources
    are created before they can be used in other monitoring resources.
  EOT
}

#
# Revere (https://github.com/broadinstitute/revere)
#

variable "revere_label_configuration" {
  type = object({
    enable_revere_service_labels = bool
    revere_service_name          = string
    revere_service_environment   = string
    revere_alert_type_latency    = string
  })
  default     = null
  description = <<-EOT
    Configuration for alert labels allowing Revere to understand alerts.

    If not provided, no labels will be added. Only used if alerts are enabled. Can be overridden
    per-endpoint in `endpoints`.

    More information is available
    [here](https://github.com/broadinstitute/revere/blob/main/docs/gcp_alert_policy_labels.md).
  EOT
}

#
# Endpoints
#

variable "default_endpoint_config" {
  type = object({
    fully_qualified_domain_name = string

    enable_alerts                   = optional(bool)
    alert_threshold_milliseconds    = optional(number)
    alert_rolling_window_minutes    = optional(number)
    alert_rolling_window_percentile = optional(number)
    alert_retest_window_minutes     = optional(number)
    alert_notification_channels     = optional(list(string))
  })
  description = <<-EOT
    Set default configurations across all `endpoints`. Any attributes not set
    will use the default values.

    Required:
    - `fully_qualified_domain_name` must be a full and exact domain name

    Optionally set:
    - `alert_threshold_milliseconds` must be a positive whole number, for the latency limit to trigger on.
    - `alert_rolling_window_minutes` must be at least 1, for the window to aggregate data.
    - `alert_rolling_window_percentile` must be one of 5, 50, 95, or 99, for the percentile to track.
    - `alert_retest_window_minutes` must be a non-negative number, for the duration the issue must persist
    after being triggered by the rolling window before truly sending the alert.
    - `alert_notification_channels` is a list of any pre-existing channel IDs in the project to notify.
  EOT
  # Note defaults here so it appears in documentation
  default = {
    fully_qualified_domain_name     = null
    enable_alerts                   = false
    alert_threshold_milliseconds    = 1000
    alert_rolling_window_minutes    = 5
    alert_rolling_window_percentile = 99
    alert_retest_window_minutes     = 0
    alert_notification_channels     = []
  }
}

locals {
  # Merge defaults here in case only some values passed via default_endpoint_config
  baseline_endpoint_config = merge(
    { alert_notification_channels = [] },
    defaults(var.default_endpoint_config, {
      enable_alerts                   = false
      alert_threshold_milliseconds    = 1000
      alert_rolling_window_minutes    = 5
      alert_rolling_window_percentile = 99
      alert_retest_window_minutes     = 0
    })
  )
}

variable "endpoints" {
  type = map(object({
    endpoint_regex = string
    request_method = optional(string)

    fully_qualified_domain_name = optional(string)

    enable_alerts                   = optional(bool)
    alert_threshold_milliseconds    = optional(number)
    alert_rolling_window_minutes    = optional(number)
    alert_rolling_window_percentile = optional(number)
    alert_retest_window_minutes     = optional(number)
    alert_notification_channels     = optional(list(string))

    enable_revere_service_labels = optional(bool)
    revere_service_name          = optional(string)
    revere_service_environment   = optional(string)
    revere_alert_type_latency    = optional(string)
  }))
  description = <<-EOT
    Configure each endpoint pattern to track the latency of. Each entry's key is used for naming
    cloud resources, and the value attributes set how to identify the endpoint and any overrides
    for the domain name, alert, or Revere alert label configuration.

    - `endpoint_regex` should start with the leading "/", and remember that characters must be escaped through Terraform
    - `request_method`, if provided, should be an all-caps HTTP method like "GET" or "POST" 
  EOT
  default     = {}
}

locals {
  # - "Disabled" is equivalent to "zero endpoints specified"
  # - We can't use `merge` because config's `null`s are considered non-empty
  # - We can't use `defaults` because it has poor handling of simply-typed lists (notification channels),
  #   and we can't remove that from the baseline config object without complicating the configuration UX
  # - This leaves us with `coalesce` as a function that actually intelligently handles `null`
  partially_merged_endpoints = var.enabled ? {
    for name, config in var.endpoints : name => {
      endpoint_regex = config.endpoint_regex
      request_method = config.request_method

      fully_qualified_domain_name = coalesce(config.fully_qualified_domain_name, local.baseline_endpoint_config.fully_qualified_domain_name)

      enable_alerts                   = coalesce(config.enable_alerts, local.baseline_endpoint_config.enable_alerts)
      alert_threshold_milliseconds    = coalesce(config.alert_threshold_milliseconds, local.baseline_endpoint_config.alert_threshold_milliseconds)
      alert_rolling_window_minutes    = coalesce(config.alert_rolling_window_minutes, local.baseline_endpoint_config.alert_rolling_window_minutes)
      alert_rolling_window_percentile = coalesce(config.alert_rolling_window_percentile, local.baseline_endpoint_config.alert_rolling_window_percentile)
      alert_retest_window_minutes     = coalesce(config.alert_retest_window_minutes, local.baseline_endpoint_config.alert_retest_window_minutes)
      alert_notification_channels     = coalesce(config.alert_notification_channels, local.baseline_endpoint_config.alert_notification_channels)

      enable_revere_service_labels = coalesce(config.enable_revere_service_labels, var.revere_label_configuration.enable_revere_service_labels)
      revere_service_name          = coalesce(config.revere_service_name, var.revere_label_configuration.revere_service_name)
      revere_service_environment   = coalesce(config.revere_service_environment, var.revere_label_configuration.revere_service_environment)
      revere_alert_type_latency    = coalesce(config.revere_alert_type_latency, var.revere_label_configuration.revere_alert_type_latency)
    }
  } : {}
  final_computed_endpoints = {
    for name, config in local.partially_merged_endpoints : name => merge(
      config,
      {
        computed_regex = "https://${replace(config.fully_qualified_domain_name, ".", "\\.")}${config.endpoint_regex}"
      }
    )
  }
}
