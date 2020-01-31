
output "cloudsql-public-ip" {
  value = var.enable_flag == "0" ? "" : google_sql_database_instance.cloudsql-instance.0.first_ip_address
}

output "cloudsql-instance-name" {
  value = var.enable_flag == "0" ? "" : google_sql_database_instance.cloudsql-instance.0.name
}
