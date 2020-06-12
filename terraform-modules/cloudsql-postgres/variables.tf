#
# General vars
#

variable "project" {
  type = string
  description = "Google project"
}

variable "enable" {
  type = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default = true
}

# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable dependencies {
  type        = any
  default     = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

#
# CloudSQL vars
#

variable "cloudsql_name" {
  type = string
  default = "cloudsql"
  description = "DNS CNAME record target hostname for default instance in an env. Should be set as a vault env override for each env."
}

variable "cloudsql_region" {
  type = string
  default = "us-central1"
  description = "The region for CloudSQL instances. NOTE: For Gen 2 instance, use standard gcloud regions."
}

variable "cloudsql_version" {
  type = string
  default = "POSTGRES_9_6"
  description = "The version to use for CloudSQL instances."
}

variable "cloudsql_require_ssl" {
  type = bool
  default = true
  description = "Determines if SSL is required for connections to CloudSQL instances."
}

variable "cloudsql_tier" {
  type = string
  default = "db-custom-16-32768" # match sam postgres in prod
  description = "The default tier (DB instance size) for CloudSQL instances"
}

variable "cloudsql_disk_autoresize" {
  type = bool
  default = true
  description = "Determines if the CloudSQL instances will increase their disk size automatically"
}

variable "cloudsql_disk_type" {
  type = string
  default = "PD_SSD"
  description = "The default disk type for CloudSQL instances"
}

variable "cloudsql_activation_policy" {
  type = string
  default = "ALWAYS"
  description = "The default activation policy for CloudSQL instances"
}

variable "cloudsql_replication_type" {
  type = string
  default = "SYNCHRONOUS"
  description = "The default replication type for CloudSQL instances"
}

variable "postgres_availability_type" {
  type        = string
  default     = "REGIONAL"
  description = "Postgres availability type"
}

# variable "cloudsql_maintenance_window_enable" {
#   default = "0"
#   description = "Enable custom GCE sql instance maintenance window for CloudSQL instances."
# }

# variable "cloudsql_maintenance_window_day" {
#   default = "6"
#   description = "The default day of the week for the custom GCE sql instance maintenance window for CloudSQL instances. Valid values: 1-7 (Monday = 1; Sunday = 7)."
# }

# variable "cloudsql_maintenance_window_hour" {
#   default = "7"
#   description = "The default hour of the day for the custom GCE sql instance maintenance window for CloudSQL instances. Valid values: 0-23."
# }

# variable "cloudsql_maintenance_window_update_track" {
#   default = "stable"
#   description = "The default update track for determining the relative order for receiving GCE sql instance updates during a maintenance window for CloudSQL instances. Valid values: stable (receive later), or canary (receive earlier). Note: These values are relative to each other for GCE sql instances within a single GCE project."
# }

variable "app_dbs" {
  description = "List of db name and username pairs"
  type = map(object({
    db = string
    username = string
  }))
  default = {
    default = {
      db = "appdb"
      username = "appuser"
    }
  }
}
locals {
  app_dbs = var.enable ? var.app_dbs : {}
}

variable "cloudsql_instance_labels" {
  type = map
  description = "CloudSQL instance labels"
  default = {}
}

variable "cloudsql_authorized_networks" {
  type = list(string)
  description = "CloudSQL authorized  networks"
  default = []
}

# private sql vars

variable "private_enable" {
  type = bool
  description = "Enable flag for a private sql instance if set to true, a private sql isntance will be created."
  default = false
}

variable "private_network" {
  type = string
  description = "Name of the projects network that the NAT/VPC pairing sql ip will be put on."
}
