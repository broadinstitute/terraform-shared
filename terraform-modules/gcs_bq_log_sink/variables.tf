variable "application_name" {
}

variable "owner" {
}

variable "project" {
}

variable "log_filter" {
}

variable "nonce" {
  default = ""
}

variable "bigquery_retention_days" {
  default = 31
}

variable "enable_bigquery" {
  default = 0
}

variable "enable_gcs" {
  default = 0
}

variable "enable_pubsub" {
  default = 0
}
