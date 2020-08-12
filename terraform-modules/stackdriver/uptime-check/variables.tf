#
# General Vars
#

variable "enabled" {
  type        = bool
  description = "enable flag for uptime check module "
}

variable "google_project" {
  type        = string
  description = "Google project in which to create the uptime check and notification channels"
}

variable "timeout" {
  type        = string
  description = "The number of seconds before the check will automatically fail after not receiving a response"
  default     = "10s"
}

variable "service" {
  type        = string
  description = "The name of the service uptime check will monitor"
}

locals {
  check_name = "${var.service}-uptime"
}

#
# Uptime Check Configuration Vars
# 
