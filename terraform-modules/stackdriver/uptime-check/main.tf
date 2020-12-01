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
 * This module supports sending alerts via cloud monitoring notfication channels. Sending alerts to one or multiple
 * slack channels is also supported.
 *
 *
 * This documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs) `terraform-docs markdown --no-sort . > README.md`
 */
