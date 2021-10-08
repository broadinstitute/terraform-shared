# latency-tracking

Terraform module enabling per-endpoint latency tracking and alerting based on Google external HTTPS load balancers. 

Note that services without an external HTTPS load balancer--for example, without a standard ingress--cannot be used with this module.

> ### Note for the implementation-curious:
> This module makes use of the null provider, local-exec provisioner, and manual depends_on relationships to have the applying Terraform
> executable literally run `sleep` in between applying the three different resource classes here. This is to avoid race conditions
> on Google's end where a metric or alert can't immediately be referenced from an alert or dashboard.
>
> Briefly, the null resources are empty resources that "trigger" exactly once based on changes to endpoints or alerts, that triggering causes
> local-exec's `sleep`s to run, and manual depends_on relationships prevent other resources from starting until the sleeps are done.

These docs are computed with `terraform-docs .`

[//]: # (BEGIN_TF_DOCS)

## Example

```hcl
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

```

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.15)

- <a name="requirement_google"></a> [google](#requirement\_google) (>=3.65.0)

- <a name="requirement_null"></a> [null](#requirement\_null) (>=3.1.0)

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

### <a name="input_resource_creation_delay_seconds"></a> [resource\_creation\_delay\_seconds](#input\_resource\_creation\_delay\_seconds)

Description: Number of seconds to wait between creation of metrics/alerts and alerts/dashboard. Set to 0 to disable.

This is a hack! It is necessary because it apparently takes a split second **after** TF believes resources  
are created before they can be used in other monitoring resources.

Type: `number`

Default: `3`

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

Description: Set default configurations across all `endpoints`. Any attributes not set  
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

Type:

```hcl
object({
    fully_qualified_domain_name = string

    enable_alerts                   = optional(bool)
    alert_threshold_milliseconds    = optional(number)
    alert_rolling_window_minutes    = optional(number)
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
  "enable_alerts": false,
  "fully_qualified_domain_name": null
}
```

### <a name="input_endpoints"></a> [endpoints](#input\_endpoints)

Description: Configure each endpoint pattern to track the latency of. Each entry's key is used for naming  
cloud resources, and the value attributes set how to identify the endpoint and any overrides  
for the domain name, alert, or Revere alert label configuration.

- `endpoint_regex` should start with the leading "/", and remember that characters must be escaped through Terraform
- `request_method`, if provided, should be an all-caps HTTP method like "GET" or "POST"

Type:

```hcl
map(object({
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
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url)

Description: The URL of the created dashboard, or null if no endpoints are being tracked.

[//]: # (END_TF_DOCS)
