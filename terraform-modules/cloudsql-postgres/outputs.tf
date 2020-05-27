output "public_ip" {
  value = var.enable ? google_sql_database_instance.cloudsql_instance[0].first_ip_address : null
}

output "instance_name" {
  value = var.enable ? google_sql_database_instance.cloudsql_instance[0].name : null
}

output "root_user_password" {
  value = var.enable ? random_id.root_user_password[0].hex : null
  sensitive = true
}

output "app_db_creds" {
  value = var.enable ? {
    for db in keys(google_sql_database.app_database):
    db => {
      db = google_sql_database.app_database[db].name
      username = google_sql_user.app_user[db].name
      password = google_sql_user.app_user[db].password
    }
  } : null
  sensitive = true
}
