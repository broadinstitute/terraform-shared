#
# CloudSQL Instance
#

resource "random_id" "cloudsql_id" {
  count = var.enable ? 1 : 0

  byte_length   = 8
}

resource "google_sql_database_instance" "cloudsql_instance" {
  count = var.enable ? 1 : 0

  provider              = google.target
  project               = var.project
  region                = var.cloudsql_region
  database_version      = var.cloudsql_version
  name                  = "${var.cloudsql_name}-${random_id.cloudsql_id[0].hex}"
  depends_on            = [ random_id.cloudsql_id, var.dependencies, google_service_networking_connection.private_vpc_connection ]

  settings {

    # POSTGRES CONFIG
    availability_type   = var.postgres_availability_type

    activation_policy   = var.cloudsql_activation_policy
    disk_autoresize     = var.cloudsql_disk_autoresize
    disk_type           = var.cloudsql_disk_type
    replication_type    = var.cloudsql_replication_type
    tier                = var.cloudsql_tier

    backup_configuration {
      binary_log_enabled    = false
      enabled               = true
      start_time            = "06:00"
    }

#    maintenance_window {
#        day             = "${var.cloudsql_maintenance_window_day}"
#        hour            = "${var.cloudsql_maintenance_window_hour}"
#        update_track    = "${var.cloudsql_maintenance_window_update_track}"
#    }

    ip_configuration {
      ipv4_enabled  = var.private_enable == true ? false : true
      private_network = var.private_enable == true ? data.google_compute_network.network.self_link : null
      require_ssl   = true
      dynamic "authorized_networks" {
        for_each = var.cloudsql_authorized_networks
        content {
          value = authorized_networks.value
        }
      }
    }

    user_labels = var.cloudsql_instance_labels
  }
}
## private sql instance code
data "google_compute_network" network {
  provider = google.target
  name = var.private_network
  depends_on = [var.dependencies]
}

resource "google_compute_global_address" "private_ip_address" {
  count = var.private_enable ? 1 : 0

  provider      = google.target
  name          = "${var.cloudsql_name}-private-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = data.google_compute_network.network.self_link
  depends_on    = [var.dependencies]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count = var.private_enable ? 1 : 0

  provider                = google.target
  network                 = data.google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address[0].name]
  depends_on              = [var.dependencies, google_compute_global_address.private_ip_address]
}
