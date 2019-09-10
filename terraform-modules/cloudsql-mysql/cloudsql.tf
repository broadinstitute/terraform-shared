#
# CloudSQL Instance
#

resource "random_id" "cloudsql-id" {
  byte_length   = 8
}

resource "google_sql_database_instance" "cloudsql-instance" {
  provider              = "google.target"
  count                 = "${var.enable_flag}"
  region                = "${var.cloudsql_region}"
  database_version      = "${var.cloudsql_version}"
  name                  = "${var.cloudsql_name}-${random_id.cloudsql-id.hex}"
  depends_on            = [ "random_id.cloudsql-id" ]

  settings {

    activation_policy   = "${var.cloudsql_activation_policy}"
    disk_autoresize     = "${var.cloudsql_disk_autoresize}"
    disk_type           = "${var.cloudsql_disk_type}"
    replication_type    = "${var.cloudsql_replication_type}"
    tier                = "${var.cloudsql_tier}"

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
      ipv4_enabled  = true
      require_ssl   = true
      dynamic "authorized_networks" {
        for_each = var.cloudsql_authorized_networks
        content {
          value = authorized_networks.value
        }
      }
    }

    database_flags {
      name  = "log_output"
      value = "FILE"
    }

    database_flags {
      name  = "sql_mode"
      value = "STRICT_ALL_TABLES"
    }

    database_flags {
      name  = "slow_query_log"
      value = "on"
    }

    database_flags {
      name  = "general_log"
      value = "on"
    }

    database_flags {
      name  = "query_cache_type"
      value = "1"
    }

    database_flags {
      name  = "query_cache_limit"
      value = "1048576"
    }

    database_flags {
      name  = "query_cache_size"
      value = "10485760"
    }

    database_flags {
      name  = "innodb_autoinc_lock_mode"
      value = "2"
    }

    database_flags {
      name  = "max_allowed_packet"
      value = "1073741824"
    }

    user_labels = "${var.cloudsql_instance_labels}"

  }
}
