# Required Variables

variable "policy_name" {
  type        = string
  description = "Display name to be associated with a particular alerting policy"
}

variable "condition_combine_method" {
  type        = string
  description = "logic to trigger the alert when multiple conditions are present only 'AND' and 'OR' are valid arguments"
}

variable "project" {
  type        = string
  description = "The GCP project the alert policy should be created under"
}

variable "cluster_name" {
  type        = string
  description = " Name of the cluster the alert policy will monitor"
}

# Optional Variables 

variable "notification_channels" {
  type        = list(string)
  default     = ["projects/dsp-tools-k8s/notificationChannels/4364517073973429755"]
  description = "List of channels that should be pinged when alert fires. Array entries must be of form: projects/[PROJECT_ID]/notificationChannels/[CHANNEL_ID]"

}

variable "node_cpu_threshold" {
  type        = number
  default     = 0.95
  description = "The threshold the cpu utilization on a node must be above to trigger the alert. Represents a fraction and must be between 0 and 1"
}

variable "node_memory_threshold" {
  type        = number
  default     = 0.95
  description = "The threshold memory utilization on a node to trigger an alert. Represents a fraction of allocatble memory and must be between 0 and 1"
}

variable "node_health_check_threshold" {
  type        = number
  default     = 0
  description = "Will trigger in alert if any of the node health check conditions are in failing or unknown state"
}

variable "cluster_pod_capacity_threshold" {
  type        = number
  default     = 0.95
  description = "The ratio of number of currently running pods to the cluster capactiy for pods"
}

variable "cluster_threshold_duration" {
  type        = string
  default     = "300s"
  description = "The amount of time a cluster health condition must violate the threshold to trigger alert"
}

variable "threshold_comparison" {
  type = object({
    less_than    = string
    greater_than = string
  })

  default = {
    less_than    = "COMPARISON_LT"
    greater_than = "COMPARISON_GT"
  }
}

variable "node_threshold_duration" {
  type        = string
  default     = "300s"
  description = "The amount of time a metric must be above a threshold in order to trigger alert. Values must be in multiples of 60"
}

variable "series_align_method" {
  type        = string
  default     = "ALIGN_MEAN"
  description = "Method for filling in time series data between collected data points. See stackdriver docs for more options"
}

variable "alignment_period" {
  type        = string
  default     = "60s"
  description = "Interval at which datapoints are sent to gcloud monitoring. Data between periods is managed series_align_method"
}

variable "reducer_method" {
  default = {
    sum = "REDUCE_SUM"
  }
  description = "Mapping of time series aggregator methods to their correct name in gcloud monitoring api. Further documentation can be found in gcloud monitoring docs"
}

variable "group_by_labels" {
  default = {
    node_name             = "resource.labels.node_name"
    node_health_condition = "metric.label.condition"
    cluster_name          = "resource.labels.cluster_name"
  }
  description = "Mapping of monitored resource labels to their gcloud monitoring api name. Used for aggregating timeseries data together"
}


###### Monitoring Metric Definitions ######

# Note: Do not adjust values below without consulting with DevOps

variable "node_cpu_metric" {
  type        = string
  default     = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
  description = "Metric used for tracking node cpu utilization"
}

variable "node_memory_metric" {
  type        = string
  default     = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" resource.type=\"k8s_node\""
  description = "Metric used for tracking allocatable memory available per node"
}

variable "node_health_metric" {
  type        = string
  default     = "metric.type=\"external.googleapis.com/prometheus/kube_node_status_condition\" resource.type=\"k8s_container\" metric.label.\"condition\"!=\"Ready\" metric.label.\"status\"!=\"false\""
  description = "Metric used for examing general kubernetes node health. This metric reports on a number of k8s specific and non-k8s indicators of node health"
}

variable "cluster_pod_capacity_metric" {
  type        = string
  default     = "metric.type=\"external.googleapis.com/prometheus/kube_node_status_capacity_pods\" resource.type=\"k8s_container\""
  description = "Metric used to determine the total number of pods that could run on a cluster"
}

variable "cluster_pod_running_metric" {
  type        = string
  default     = "metric.type=\"external.googleapis.com/prometheus/kube_pod_status_phase\" resource.type=\"k8s_container\" metric.label.\"phase\"=\"Running\""
  description = "Metric that describes the number of pods currently running on a pod. Does not include kube-system or prometheus pods"
}
