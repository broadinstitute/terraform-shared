# Stackdriver SLO Monitoring module

This module faciliates easy setup of monitoring on the external availability of Terra services.  
The module will create alert policies which monitor SLO metrics based on the following [document](https://docs.google.com/document/d/15YhNvO4pPC-R3mA1rgZIdlXJzmOHm3kIv1rLo4xWZ_g/edit).  
This module will be maintained to remain in sync with that document.

Currently the metrics that are monitored by this module are the success/failure of a ping to a status endpoint  
and average request latency. With default configuration alerts will fire if an uptime check fails for  > 5 minutes or  
latency is above 2500ms for > 5 minutes

This module supports sending alerts via slack and pagerduty. Alerting via pagerduty can only be enabled in production  
environments and is specified via the `enable_pagerduty` flag, no other action is needed. Sending alerts to one or multiple  
slack channels is also supported. Slack channels must be passed in as a list of the form `slack_channels = ["#channel-name",...]`
### In order for alerts to fire properly to slack make sure the bot user `@terraformstackdriver` is added to your channel

This documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs) `terraform-docs markdown --no-sort . > README.md`

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| google | ~> 3.9 |
| vault | ~> 2.12 |

## Providers

| Name | Version |
|------|---------|
| vault | ~> 2.12 |
| google | ~> 3.9 |
| google.target | ~> 3.9 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | enable flag for uptime check module | `bool` | n/a | yes |
| google\_project | Google project in which to create the uptime check and notification channels | `string` | n/a | yes |
| timeout | The number of seconds before the check will automatically fail after not receiving a response | `string` | `"10s"` | no |
| service | The name of the service uptime check will monitor | `string` | n/a | yes |
| path | The URI path to the service's status endpoint | `string` | `"/status"` | no |
| https\_enabled | Flag to enable tls for the uptime check | `bool` | `true` | no |
| resource\_type | The GCP resource type that the uptime check will monitor. Defaults to checking a fqdn | `string` | `"uptime_url"` | no |
| fqdn | The fully qualified domain name to be used by the uptime check | `string` | n/a | yes |
| alert\_type | The platform an alert will be sent to if the uptime check fails ie: slack, pagerduty etc | `string` | `"slack"` | no |
| channel\_names | The slack channel the alert should fire to | `list(string)` | `[]` | no |
| ssl\_alert\_channel | The slack channel where ssl expiration alerts should go | `string` | `"#ap-devops"` | no |
| enable\_pagerduty | Boolean flag to indicate if DSDE pagerduty will be triggered when one of associated alerts fires. Can only be enabled in broad-dsde-prod | `bool` | `false` | no |
| pagerduty\_channel | display name of the pagerduty integration in stackdriver | `string` | `""` | no |
| combiner | Logical operator applied to conditions associated with an alert. Default behavior is to alert if any condition triggers | `string` | `"OR"` | no |
| comparison | Comparison between a threshold value and current time series value that determines if an alert should fire. Valid inputs are COMPARISON\_GT and COMPARISON\_LT. Default behavior is to trigger alert if current value is above a threshold | `string` | `"COMPARISON_GT"` | no |
| duration | Amount of time a series must violate a theshold before an alert triggers. Default is to trigger alert after 5 minutes violating a threshold | `string` | `"300s"` | no |
| latency\_threshold | Latency in ms that must be exceeded for 5 minutes to trigger the alert | `string` | `"2500"` | no |
| ssl\_threshold | number of days before a particular ssl expires an alert will trigger | `string` | `"45"` | no |
| vault\_addr | n/a | `string` | `"https://clotho.broadinstitute.org:8200"` | no |

## Outputs

No output.

