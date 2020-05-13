# Google App Engine Monitoring

This module is intended to configure base set of monitoring policies for GAE apps that checks for overall application availability and health.

## Usage 
This module will create alerting policies in the stackdriver workspace that monitors the gcp project the GAE app is hosted in. Currently as of 4/1/20 If the app is becing deployed to prod, the stackdriver gcp project and GAE app project will both be broad-dsde-prod. For any other environment this module will need to use a google provider configured to target the broad-dsp-stackdriver project (this is likely to change in the future)

### Example basic usage: 
```
module "gae_alerts" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/stackdriver/path/to/this/module"
  providers = {
    google.target = google.stackdriver_host
  }

  service_name     = "GAE_module_name"
  gae_host_project = "GAE_HOST_PROJECT_ID"
}
```

## Alerting Policies

The following are the metrics that this module will set up monitoring on and the thresholds needed to trigger the alerts.

### Reponse Status Codes
If the application is responding with 500 status or a higher than usual number of 400 status, this may be indicative of an issue and should trigger an alert

### Response Latency
If the application is experiencing significantly greater latency than normal operation for an extended period of time, this may be indicative of a promblem and should trigger an alert. 

### DOS Intercepts
This metric measures requests that are intercepted to prevent DOS attacks. A non-zero value for this metric is indicative of a secuirty issue or other problem that may effect service availability.

### Quota Denials
This metric counts request that fail due to exceeding any of the gae per minute quotas. This can be used to tell when requests to the service are failing due to excessive quota usage. Usually this pertains to the amount of data received and sent by the app.

### CPU and Memory Usage
Unusually high values for cpu and memory utilization metrics for extended periods of time are common indicators that the application is not running in a normal state and should trigger an alert.