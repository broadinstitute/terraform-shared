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
  value = substr(google_dns_record_set.dns-a.*.name, 0, length(google_dns_record_set.dns-a.*.name) - 1)
}

output "instance_priv_hostnames" {
  value = substr(google_dns_record_set.dns-a-priv.*.name, 0, length(google_dns_record_set.dns-a-priv.*.name) - 1)
}

output "instance_instance_group" {
  value = "${module.instances.instance_instance_group}"
}

output "config_bucket_name" {
  value = "${google_storage_bucket.config-bucket.name}"
}
