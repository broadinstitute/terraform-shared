
resource "random_id" "random-password" {
  count = "${var.enable_flag}"
  byte_length   = 16
}

resource "google_sql_user" "app-user" {
  provider              = "google.target"
  count                 = "${var.enable_flag}"
  instance  = "${google_sql_database_instance.cloudsql-instance.name}"
  name      = "${var.cloudsql_database_user_name}"
  host      = "%"
  password  = "${var.cloudsql_database_user_password == ""?random_id.random-password.hex:var.cloudsql_database_user_password}"
  depends_on = ["google_sql_database_instance.cloudsql-instance" ]
}

resource "google_sql_user" "root-user" {
  provider              = "google.target"
  count                 = "${var.enable_flag}"
  instance  = "${google_sql_database_instance.cloudsql-instance.name}"
  name      = "root"
  host      = "%"
  password  = "${var.cloudsql_database_root_password == ""?random_id.random-password.hex:var.cloudsql_database_root_password}"
  depends_on = ["google_sql_database_instance.cloudsql-instance" ]
}

