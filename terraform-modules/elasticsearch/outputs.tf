output "instance_public_ips" {
  value = "${module.instances.instance_public_ips}"
}

output "cluster_name" {
  value = "${var.owner}-${var.service}"
}

output "instance_private_ips" {
  value = "${module.instances.instance_private_ips}"
}

output "instance_names" {
  value = "${module.instances.instance_names}"
}

output "instance_hostnames" {
  value = data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname
}

output "instance_priv_hostnames" {
  value = data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname_priv
}

output "instance_instance_group" {
  value = "${module.instances.instance_instance_group}"
}

output "config_bucket_name" {
  value = "${google_storage_bucket.config-bucket.name}"
}
