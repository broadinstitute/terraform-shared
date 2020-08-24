/**
 * # Stackdriver SLO Monitoring module
 * 
 * This module faciliates easy setup of monitoring on the external availability of Terra services.
 * The module will create alert policies which monitor SLO metrics based on the following [document](https://docs.google.com/document/d/15YhNvO4pPC-R3mA1rgZIdlXJzmOHm3kIv1rLo4xWZ_g/edit).
 * This module will be maintained to remain in sync with that document. 
 * 
 * Currently the metrics that are monitored by this module are the success/failure of a ping to a status endpoint 
 * and average request latency. With default configuration alerts will fire if an uptime check fails for  > 5 minutes or
 * latency is above 2500ms for > 5 minutes
 *
 * This module supports sending alerts via slack and pagerduty. Alerting via pagerduty can only be enabled in production
 * environments and is specified via the `enable_pagerduty` flag, no other action is needed. Sending alerts to one or multiple
 * slack channels is also supported. Slack channels must be passed in as a list of the form `channel_names = ["#channel-name",...]`
 * ### In order for alerts to fire properly to slack make sure the bot user `@terraformstackdriver` is added to your channel
 *
 * This module also creates a few Ops specific alerts that alert the DevOps team directly. No additional inputs are needed.
 *
 * This documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs) `terraform-docs markdown --no-sort . > README.md`
 */
