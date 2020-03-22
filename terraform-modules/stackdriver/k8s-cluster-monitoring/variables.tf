# Required Variables

variable "policy_name" {
  type        = string
  description = "Display name to be associated with a particular alerting policy"
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
  type = list(string)
  # ap-devops slack channel
  default     = ["projects/dsp-tools-k8s/notificationChannels/4364517073973429755"]
  description = "List of channels that should be pinged when alert fires. Array entries must be of form: projects/[PROJECT_ID]/notificationChannels/[CHANNEL_ID]"
}

variable "threshold_duration" {
  type        = string
  default     = "300s"
  description = "The amount of time a condition must violate the threshold to trigger alert"
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
    namespace_name        = "resource.label.namespace_name"
    deployment            = "metric.label.deployment"
    pod_name              = "resource.label.pod_name"
  }
  description = "Mapping of monitored resource labels to their gcloud monitoring api name. Used for aggregating timeseries data together"
}
