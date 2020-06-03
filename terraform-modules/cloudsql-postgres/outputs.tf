output "public_ip" {
  value = var.enable ? google_sql_database_instance.cloudsql_instance[0].first_ip_address : null
  depends_on = [google_sql_database_instance.cloudsql_instance]
}

output "instance_name" {
  value = var.enable ? google_sql_database_instance.cloudsql_instance[0].name : null
  depends_on = [google_sql_database_instance.cloudsql_instance]
}

output "connection_name" {
  value = var.enable ? google_sql_database_instance.cloudsql_instance[0].connection_name : null
}

output "root_user_password" {
  value      = var.enable ? random_id.root_user_password.*.hex : null
  sensitive  = true
  depends_on = [random_id.root_user_password]
}

output "app_db_creds" {
  value = var.enable ? {
    for db in keys(google_sql_database.app_database) :
    db => {
      db       = google_sql_database.app_database[db].name
      username = google_sql_user.app_user[db].name
      password = google_sql_user.app_user[db].password
    }
  } : null
  depends_on = [google_sql_user.app_user,google_sql_database.app_database]
}
