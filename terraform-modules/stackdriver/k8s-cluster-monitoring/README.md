# Gcloud K8s Monitoring
This module is used to create a set of alerting policies in gcloud monitoring which monitor a kubernetes cluster for overall health. The module utilizes a variety of metrics to examine cluster health at cluster-wide, node and pod levels. This module is intended to configure application agnostic alerts only, its scope is to the monitor the general health of the cluster and k8s resources within it.

## Note
This module assumes that your cluster has prometheus and kube-state-metrics installed and configured to export metrics to gcloud monitoring. You can use this [helm chart](placeholder) to configure this automatically.


## Usage
**This module is intended to be run with default settings only.** 

This set of alerting policies is intended to be consistent across all clusters managed by ap-devops. All configuration regarding which metrics the alert policies monitor and the thresholds needed to trigger alerts are managed by locals to ensure they are not overidden accidentally. If conditions or thresholds for these policies need to be added or updated this should be handled by ap-devops.

THe only parameter users of this module need to provide is the id of the gcp project the alerts will be created in. An example usage of the module is provided below. 

```
module "k8s-cluster-alerts" {
  source = "https://github.com/broadinstitute/terraform-shared/path/to/this/module"
  providers = {
    google.target = google.target
  }

  project = "YOUR_GCP_PROJECT_ID"
}
```

## Policy Documentation

### K8s-cluster-health
This policy will trigger if the number of pods running on a cluster is approaching the maximum number of pods the cluster can support. This can indicate problems where the scheduler may start evicting crucial pods in order to make more room. This alert is intended and as final line of defense and issues should be caught by lower level alerts before propagating to this level. If this ratio is above 95% for more than 5 minutes an alert will be triggered. This policy utilizes prometheus metrics

### K8s-deployment-health
This policy monitors the ratio of pods a deployment is currently running vs the number of pods requested in the deployment spec. If these numbers do not match and an update is in progress then this is indicative of an issue and an alert will be fired if this ratio is not equal to 1 for greater than 5 minutes. The alert will provide details about which cluster and namespace are associated with the deployment that triggered the alert. This policy utilizes prometheus metrics

### K8s-node-health
This policy monitors a variety of different indicators of node health using passing/failing states. These indicators are: 
- Corrupt Docker Overlay
- Disk Pressure
- Memory Pressure
- Frequent Container Restarts
- Frequent Docker Restarts
- Frequent Kubelet Restarts
- Kernel Deadlock
- Network Unavailable
- PID Pressure

If any of these are in a failing state for more than 5 minutes an alert will fire. This policy utilizes prometheus metrics

### k8s-node-resource-utilization
This policy monitors the cpu and memory utilization ratios of each node in a cluster. This alert policy will trigger if either resource utilization is above a set threshold percentage for greater than 5 minutes. Not reliant on prometheus

### K8s-pod-health
This policy monitors for any pods that are not able to be run by the scheduler for an extended period of time. This alert fires if a pod is in failed to schedule state for greater than 5 minutes. The alert will specify which cluster and namespace are associated with the pod that triggered the alert.

### K8s-pod-resource utilization 
This policy monitors the ratio of the current cpu and memory being used by a pod to the limit for that resource set in the pod spec. It also monitors volume utilization at the pod level. This is important to monitor because it can cause the scheduler to OOMkill pods automatically potentially killing crucial application pods. Not reliant on prometheus. THe alert will provide the cluster and namespace of the pod that triggered the alert.

## Notifications
Currently the default on this module is to send all alert notifications to ap-devops slack. A potential feature to add would to have notification channels configured based on a passed in environment ie. pager duty for prod, slack for others.
