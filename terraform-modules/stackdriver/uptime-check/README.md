# Stackdriver SLO Monitoring module

This module faciliates easy setup of monitoring on the external availability of Terra services.
The module will create alert policies which monitor SLO metrics based on the following [document](https://docs.google.com/document/d/15YhNvO4pPC-R3mA1rgZIdlXJzmOHm3kIv1rLo4xWZ_g/edit).
This module will be maintained to remain in sync with that document.

Currently the metrics that are monitored by this module are the success/failure of a ping to a status endpoint
and average request latency. With default configuration alerts will fire if an uptime check fails for  > 5 minutes or
latency is above 2500ms for > 5 minutes

This module supports sending alerts via cloud monitoring notfication channels. Sending alerts to one or multiple
slack channels is also supported.

This documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs) `terraform-docs markdown --no-sort . > README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google.target"></a> [google.target](#provider\_google.target) | ~> 3.9 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_monitoring_alert_policy.uptime_alert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_uptime_check_config.uptime_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | enable flag for uptime check module | `bool` | `true` | no |
| <a name="input_google_project"></a> [google\_project](#input\_google\_project) | Google project in which to create the uptime check and notification channels | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The number of seconds before the check will automatically fail after not receiving a response | `string` | `"10s"` | no |
| <a name="input_service"></a> [service](#input\_service) | The name of the service uptime check will monitor | `string` | n/a | yes |
| <a name="input_notification_channels"></a> [notification\_channels](#input\_notification\_channels) | List of google notification channel ids that alerts will be sent to | `list(string)` | `[]` | no |
| <a name="input_alert_labels"></a> [alert\_labels](#input\_alert\_labels) | Extra user labels to apply to the alert policy | `map(string)` | `{}` | no |
| <a name="input_revere_label_configuration"></a> [revere\_label\_configuration](#input\_revere\_label\_configuration) | Configuration for alert labels allowing Revere to understand alerts.<br><br>More information is available<br>[here](https://github.com/broadinstitute/revere/blob/main/docs/gcp_alert_policy_labels.md). | <pre>object({<br>    enable_revere_service_labels = bool<br>    revere_service_name          = string<br>    revere_service_environment   = string<br>    revere_alert_type_uptime     = string<br>  })</pre> | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | The URI path to the service's status endpoint | `string` | `"/status"` | no |
| <a name="input_https_enabled"></a> [https\_enabled](#input\_https\_enabled) | Flag to enable tls for the uptime check | `bool` | `true` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | The GCP resource type that the uptime check will monitor. Defaults to checking a fqdn | `string` | `"uptime_url"` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The fully qualified domain name to be used by the uptime check | `string` | n/a | yes |
| <a name="input_combiner"></a> [combiner](#input\_combiner) | Logical operator applied to conditions associated with an alert. Default behavior is to alert if any condition triggers | `string` | `"OR"` | no |
| <a name="input_comparison"></a> [comparison](#input\_comparison) | Comparison between a threshold value and current time series value that determines if an alert should fire. Valid inputs are COMPARISON\_GT and COMPARISON\_LT. Default behavior is to trigger alert if current value is above a threshold | `string` | `"COMPARISON_GT"` | no |
| <a name="input_duration"></a> [duration](#input\_duration) | Amount of time a series must violate a theshold before an alert triggers. Default is to trigger alert after 5 minutes violating a threshold | `string` | `"300s"` | no |
| <a name="input_latency_threshold"></a> [latency\_threshold](#input\_latency\_threshold) | Latency in ms that must be exceeded for 5 minutes to trigger the alert | `string` | `"2500"` | no |
| <a name="input_alert_documentation"></a> [alert\_documentation](#input\_alert\_documentation) | documentation to display in alert messages | `string` | `""` | no |

## Outputs

No outputs.
