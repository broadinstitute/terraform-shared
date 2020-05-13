# Required Variables
variable "service_name" {
  type        = string
  description = "Name of the gae service to be monitored"
}

variable "gae_host_project" {
  type        = string
  description = "GCP project that hosts the GAE app if it is different from project hosting the stackdriver workspace"
}

# Optional Variables

variable "https_enabled" {
  type        = bool
  default     = true
  description = "Whether the check will use https or http protocol, default is https"
}

variable "notification_channels" {
  type        = list(string)
  default     = []
  description = "List of gcloud notification channel ids that a should be alerted when the check fails"
}

variable "series_align_method" {
  default = {
    mean       = "ALIGN_MEAN"
    count_true = "ALIGN_COUNT_TRUE"
    rate       = "ALIGN_RATE"
    sum        = "ALIGN_SUM"
  }
  description = "Method for filling in time series data between collected data points. See stackdriver docs for more options"
}

variable "alignment_period" {
  type        = string
  default     = "60s"
  description = "Interval at which datapoints are sent to gcloud monitoring. Data between periods is managed series_align_method"
}

variable "reducer_method" {
  default = {
    sum           = "REDUCE_SUM"
    none          = "REDUCE_NONE"
    count         = "REDUCE_COUNT"
    percentile_99 = "REDUCE_PERCENTILE_99"
  }
  description = "Mapping of time series aggregator methods to their correct name in gcloud monitoring api. Further documentation can be found in gcloud monitoring docs"
}

variable "group_by_labels" {
  default = {
    response_code = "metric.label.response_code"
    module_id     = "resource.label.module_id"
  }
  description = "Mapping of monitored resource labels to their gcloud monitoring api name. Used for aggregating timeseries data together"
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
