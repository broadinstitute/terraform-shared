# POSTGRES CONFIG

variable "postgres_availability_type" {
  type = string
  default = "REGIONAL"
}

# module wide vars
# google project
variable "project" {}

# enable/disable var
variable "enable_flag" {
   default = "1"
}

variable "cloudsql_name" {
  default = "cloudsql"
  description = "DNS CNAME record target hostname for default instance in an env. Should be set as a vault env override for each env."
}

variable "cloudsql_region" {
  default = "us-central1"
  description = "The region for CloudSQL instances. NOTE: For Gen 2 instance, use standard gcloud regions."
}

variable "cloudsql_version" {
  default = "POSTGRES_9_6"
  description = "The version to use for CloudSQL instances."
}

variable "cloudsql_require_ssl" {
  default = "true"
  description = "Determines if SSL is required for connections to CloudSQL instances."
}

variable "cloudsql_tier" {
  default = "db-custom-16-32768" # match sam postgres in prod
  description = "The default tier (DB instance size) for CloudSQL instances"
}

variable "cloudsql_disk_autoresize" {
  default = "true"
  description = "Determines if the CloudSQL instances will increase their disk size automatically"
}

variable "cloudsql_disk_type" {
  default = "PD_SSD"
  description = "The default disk type for CloudSQL instances"
}

variable "cloudsql_activation_policy" {
  default = "ALWAYS"
  description = "The default activation policy for CloudSQL instances"
}

variable "cloudsql_replication_type" {
  default = "SYNCHRONOUS"
  description = "The default replication type for CloudSQL instances"
}

variable "cloudsql_maintenance_window_enable" {
  default = "0"
  description = "Enable custom GCE sql instance maintenance window for CloudSQL instances."
}

variable "cloudsql_maintenance_window_day" {
  default = "6"
  description = "The default day of the week for the custom GCE sql instance maintenance window for CloudSQL instances. Valid values: 1-7 (Monday = 1; Sunday = 7)."
}

variable "cloudsql_maintenance_window_hour" {
  default = "7"
  description = "The default hour of the day for the custom GCE sql instance maintenance window for CloudSQL instances. Valid values: 0-23."
}

variable "cloudsql_maintenance_window_update_track" {
  default = "stable"
  description = "The default update track for determining the relative order for receiving GCE sql instance updates during a maintenance window for CloudSQL instances. Valid values: stable (receive later), or canary (receive earlier). Note: These values are relative to each other for GCE sql instances within a single GCE project."
}

variable "cloudsql_database_name" {
  default = "database"
  description = "The default database name if not specified"
}

variable "cloudsql_database_user_name" {
  default = "appuser"
  description = "The default database application user name if not specified"
}

variable "cloudsql_database_user_password" {
  default = ""
  description = "The default database application user password if not specified"
}

variable "cloudsql_database_root_password" {
  default = ""
  description = "The default database root user password if not specified"
}

variable "cloudsql_instance_labels" {
  type = "map"
  default = {}
}

variable "cloudsql_authorized_networks" {
  type = list(string)
  default = []
}
