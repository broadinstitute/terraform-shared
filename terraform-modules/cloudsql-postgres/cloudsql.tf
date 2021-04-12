#
# CloudSQL Instance
#

resource "random_id" "cloudsql_id" {
  count = var.enable ? 1 : 0

  byte_length = 8

  keepers = var.cloudsql_keepers ? {
    database_version = var.cloudsql_version
  } : null
}

resource "google_sql_database_instance" "cloudsql_instance" {
  count = var.enable ? 1 : 0

  provider         = google.target
  region           = var.cloudsql_region
  database_version = var.cloudsql_version
  name             = "${var.cloudsql_name}-${random_id.cloudsql_id[0].hex}"
  depends_on       = [random_id.cloudsql_id, var.dependencies, google_service_networking_connection.private_vpc_connection]

  settings {

    # POSTGRES CONFIG
    availability_type = var.postgres_availability_type

    activation_policy = var.cloudsql_activation_policy
    disk_autoresize   = var.cloudsql_disk_autoresize
    disk_type         = var.cloudsql_disk_type
    replication_type  = var.cloudsql_replication_type
    tier              = var.cloudsql_tier

    backup_configuration {
      binary_log_enabled = false
      enabled            = true
      start_time         = "06:00"
      backup_retention_settings {
        retained_backups = var.cloudsql_retained_backups
      }
    }

    #    maintenance_window {
    #        day             = "${var.cloudsql_maintenance_window_day}"
    #        hour            = "${var.cloudsql_maintenance_window_hour}"
    #        update_track    = "${var.cloudsql_maintenance_window_update_track}"
    #    }

    ip_configuration {
      ipv4_enabled    = var.private_enable == true ? false : true
      private_network = var.private_enable == true ? local.private_network : null
      require_ssl     = true
      dynamic "authorized_networks" {
        for_each = var.cloudsql_authorized_networks
        content {
          value = authorized_networks.value
        }
      }
    }

    user_labels = var.cloudsql_instance_labels

    dynamic "database_flags" {
      for_each = var.cloudsql_database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

    insights_config {
      query_insights_enabled  = local.cloudsql_insights_config.query_insights_enabled
      query_string_length     = local.cloudsql_insights_config.query_string_length
      record_application_tags = local.cloudsql_insights_config.record_application_tags
      record_client_address   = local.cloudsql_insights_config.record_client_address
    }
  }
}
## private sql instance code

resource "google_compute_global_address" "private_ip_address" {
  count = var.enable_private_services ? 1 : 0

  provider      = google.target
  name          = "${var.cloudsql_name}-private-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.private_network_self_link
  depends_on    = [var.dependencies]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count = var.enable_private_services ? 1 : 0

  provider                = google.target
  network                 = var.private_network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address[0].name]
  depends_on              = [var.dependencies, google_compute_global_address.private_ip_address]
}
