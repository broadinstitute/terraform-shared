

resource "google_sql_database" "app-database" {
  provider              = "google.target"
  count = "${var.enable_flag}"
  name = "${var.cloudsql_database_name}"
  instance  = "${google_sql_database_instance.cloudsql-instance.name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
  depends_on = ["google_sql_database_instance.cloudsql-instance" ]
}
