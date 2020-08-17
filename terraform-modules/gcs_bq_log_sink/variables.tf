variable "application_name" {
}

variable "owner" {
}

variable "project" {
}

variable "log_filter" {
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

variable "dependencies" {
  # See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
  type        = any
  default     = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}
