output "instance_public_ips" {
  value = module.instances.instance_public_ips
}

output "instance_private_ips" {
  value = module.instances.instance_private_ips
}

output "instance_names" {
  value = module.instances.instance_names
}

output "instance_hostnames" {
  value = var.dns_zone_name != "none" ? data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname : []
}

output "instance_priv_hostnames" {
  value = var.dns_zone_name != "none" ? data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname_priv : []
}

output "mongo_uri" {
  value = var.dns_zone_name != "none" ? "mongodb://${var.mongodb_app_username}:${var.mongodb_app_password}@${ join(",", data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname) }/${var.mongodb_database}" : "mongodb://${var.mongodb_app_username}:${var.mongodb_app_password}@${ join(",", module.instances.instance_public_ips) }/${var.mongodb_database}"
  sensitive = true
}

output "mongo_priv_uri" {
  value = var.dns_zone_name != "none" ? "mongodb://${var.mongodb_app_username}:${var.mongodb_app_password}@${ join(",", data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname_priv) }/${var.mongodb_database}" : "mongodb://${var.mongodb_app_username}:${var.mongodb_app_password}@${ join(",", module.instances.instance_private_ips) }/${var.mongodb_database}"
  sensitive = true
}

output "instance_instance_group" {
  value = module.instances.instance_instance_group
}

output "config_bucket_name" {
  value = google_storage_bucket.config-bucket.name
}
