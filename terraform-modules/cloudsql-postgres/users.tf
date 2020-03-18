resource "random_id" "root_user_password" {
  byte_length = 16
}
resource "google_sql_user" "root_user" {
  provider  = google.target
  instance  = google_sql_database_instance.cloudsql_instance.name
  name      = "root"
  password  = random_id.root_user_password.hex
  depends_on = [ google_sql_database_instance.cloudsql_instance ]
}

resource "random_id" "app_user_password" {
  for_each  = var.app_dbs
  byte_length = 16
}
resource "google_sql_user" "app_user" {
  for_each  = var.app_dbs

  provider  = google.target
  instance  = google_sql_database_instance.cloudsql_instance.name
  name      = each.value.username
  password  = random_id.app_user_password[each.key].hex
  depends_on = [ google_sql_database_instance.cloudsql_instance ]
}
