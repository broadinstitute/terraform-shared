output "public_ip" {
  value = google_sql_database_instance.cloudsql_instance.first_ip_address
}

output "instance_name" {
  value = google_sql_database_instance.cloudsql_instance.name
}

output "root_user_password" {
  value = random_id.root_user_password.hex
  sensitive = true
}

output "app_db_creds" {
  value = {
    for db in keys(google_sql_database.app_database):
    db => {
      db = google_sql_database.app_database[db].name
      username = google_sql_user.app_user[db].name
      password = google_sql_user.app_user[db].password
    }
  }
  sensitive = true
}
