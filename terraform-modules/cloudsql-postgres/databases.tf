resource "google_sql_database" "app_database" {
  for_each = var.app_dbs

  provider  = google.target
  name      = each.value.db
  instance  = google_sql_database_instance.cloudsql_instance.name
  depends_on = [ google_sql_database_instance.cloudsql_instance ]
}
