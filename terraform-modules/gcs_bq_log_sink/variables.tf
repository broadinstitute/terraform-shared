variable "application_name" {
  type    = string
  default = ""
}

variable "owner" {
  type    = string
  default = ""
}

variable "project" {
  type    = string
  default = ""
}

variable "log_filter" {
  type    = string
  default = ""
}

variable "bigquery_retention_days" {
  default = 31
  type    = number
}

variable "enable_bigquery" {
  type    = bool
  default = false
}

locals {
  enable_bigquery = var.enable ? var.enable_bigquery : var.enable
}

variable "enable_gcs" {
  type    = bool
  default = false
}

locals {
  enable_gcs = var.enable ? var.enable_gcs : var.enable
}

variable "enable_pubsub" {
  type    = bool
  default = false
}

locals {
  enable_pubsub = var.enable ? var.enable_pubsub : var.enable
}

variable "enable" {
  type    = bool
  default = false
}

variable "dependencies" {
  # See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
  type        = any
  default     = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}
