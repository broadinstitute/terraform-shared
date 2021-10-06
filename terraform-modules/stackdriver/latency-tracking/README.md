## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_google"></a> [google](#provider\_google)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [google_logging_metric.latency_metric](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_metric) (resource)
- [google_monitoring_alert_policy.latency_alert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) (resource)
- [google_monitoring_dashboard.latency_dashboard](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_dashboard) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_google_project"></a> [google\_project](#input\_google\_project)

Description: Google project containing the load balancers with latency to track.

Type: `string`

### <a name="input_service"></a> [service](#input\_service)

Description: The name of the service to track, used for dashboard/metric/alert names.

Type: `string`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: The environment the service being tracked is in, used for dashboard/metric/alert names.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Whether this module is enabled.

Type: `bool`

Default: `true`

### <a name="input_revere_label_configuration"></a> [revere\_label\_configuration](#input\_revere\_label\_configuration)

Description: Configuration for alert labels allowing Revere to understand alerts.

If not provided, no labels will be added. Only used if alerts are enabled. Can be overridden  
per-endpoint in `endpoints`.

More information is available
[here](https://github.com/broadinstitute/revere/blob/main/docs/gcp_alert_policy_labels.md).

Type:

```hcl
object({
    enable_revere_service_labels = bool
    revere_service_name          = string
    revere_service_environment   = string
    revere_alert_type_latency    = string
  })
```

Default: `null`

### <a name="input_default_endpoint_config"></a> [default\_endpoint\_config](#input\_default\_endpoint\_config)

Description: Optionally set default alert configurations across all `endpoints`. Any attributes not set  
will use the default values.

- `alert_threshold_milliseconds` must be a positive whole number, for the latency limit to trigger on.
- `alert_rolling_window_duration` must be at least 1, for the window to aggregate data.
- `alert_rolling_window_percentile` must be one of 5, 50, 95, or 99, for the percentile to track.
- `alert_retest_window_minutes` must be a non-negative number, for the duration the issue must persist  
after being triggered by the rolling window before truly sending the alert.
- `alert_notification_channels` is a list of any pre-existing channel IDs in the project to notify.

Type:

```hcl
object({
    enable_alerts                   = optional(bool)
    alert_threshold_milliseconds    = optional(number)
    alert_rolling_window_duration   = optional(number)
    alert_rolling_window_percentile = optional(number)
    alert_retest_window_minutes     = optional(number)
    alert_notification_channels     = optional(list(string))
  })
```

Default:

```json
{
  "alert_notification_channels": [],
  "alert_retest_window_minutes": 0,
  "alert_rolling_window_minutes": 5,
  "alert_rolling_window_percentile": 99,
  "alert_threshold_milliseconds": 1000,
  "enable_alerts": false
}
```

### <a name="input_endpoints"></a> [endpoints](#input\_endpoints)

Description: Configure each endpoint pattern to track the latency of. Each entry's key is used for naming  
cloud resources, and the value attributes set how to identify the endpoint and any overrides  
for the alert or Revere alert label configuration.

For `endpoint_regex`, recall that the Regex must be escaped through Terraform.

```hcl
endpoints = {
  "status" = {
    endpoint_regex               = "https://example\\.com/status"
    enable_alerts                = true
    alert_threshold_milliseconds = 750
  }
}
```

Type:

```hcl
map(object({
    endpoint_regex = string

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
```

Default: `{}`

## Outputs

No outputs.
