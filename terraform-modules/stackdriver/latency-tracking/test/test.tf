module "latency_tracking" {
  # Adjust trailing ref to select version
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/stackdriver/latency-tracking?ref=latency-tracking-1.0.0"

  # Assume the standard set of variables and locals available within ap-deployments/terra-monitoring submodules
  enabled        = var.enable && var.allow_latency_tracking
  google_project = var.google_project
  service        = "example-service"
  environment    = terraform.workspace

  # Revere labels usually configured by parent module, leave as-is
  revere_label_configuration = var.revere_label_configuration

  # See docs for options and defaults, all can be overridden per-endpoint
  default_endpoint_config = {
    fully_qualified_domain_name = local.fqdn
    alert_notification_channels = concat(local.critical_notification_channels, local.non_critical_notification_channels)
    enable_alerts               = true
  }

  endpoints = {
    status = {
      # Only required field is `endpoint_regex`
      endpoint_regex = "/status"
    },
    version = {
      endpoint_regex = "/version"
      # Alerts can be enabled/disabled per-endpoint
      enable_alerts = false
    },
    get-person = {
      # Regex supported, but must be escaped through Terraform
      endpoint_regex = "/api/v1/person/\\d+"
      # `request_method` can optionally narrow the filter
      request_method = "GET"
    },
    post-person = {
      endpoint_regex = "/api/v1/person/\\d+"
      request_method = "POST"
      # Optional alert customization can be done in `default_endpoint_config` or here per-endpoint
      alert_threshold_milliseconds    = 1500
      alert_rolling_window_minutes    = 10
      alert_rolling_window_percentile = 99
      alert_retest_window_minutes     = 10
    }
  }
}
