
output "cloudsql-public-ip" {
  value = "${google_sql_database_instance.cloudsql-instance.0.first_ip_address}"
}
