

resource "google_sql_database" "app-database" {
  provider   = google.target
  count      = var.enable_flag
  name       = var.cloudsql_database_name
  project    = var.project
  instance   = var.enable_flag ? google_sql_database_instance.cloudsql-instance.0.name : ""
  charset    = "utf8"
  collation  = "utf8_general_ci"
  depends_on = [google_sql_database_instance.cloudsql-instance]
}
