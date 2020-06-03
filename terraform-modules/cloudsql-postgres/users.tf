resource "random_id" "root_user_password" {
  count = var.enable ? 1 : 0

  byte_length = 16
}
resource "google_sql_user" "root_user" {
  count = var.enable ? 1 : 0

  provider   = google.target
  instance   = google_sql_database_instance.cloudsql_instance[0].name
  name       = "root"
  password   = random_id.root_user_password[0].hex
  depends_on = [google_sql_database_instance.cloudsql_instance]
}

resource "random_id" "app_user_password" {
  for_each    = local.app_dbs
  byte_length = 16
}
resource "google_sql_user" "app_user" {
  for_each = local.app_dbs

  provider   = google.target
  instance   = google_sql_database_instance.cloudsql_instance[0].name
  name       = each.value.username
  password   = random_id.app_user_password[each.key].hex
  depends_on = [google_sql_database_instance.cloudsql_instance]
}
