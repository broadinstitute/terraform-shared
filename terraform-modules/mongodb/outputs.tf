output "instance_public_ips" {
  value = "${module.instances.instance_public_ips}"
}

output "instance_private_ips" {
  value = "${module.instances.instance_private_ips}"
}

output "instance_names" {
  value = "${module.instances.instance_names}"
}

output "instance_instance_group" {
  value = "${module.instances.instance_instance_group}"
}

output "config_bucket_name" {
  value = "${google_storage_bucket.config-bucket.name}"
}
