
output "instance_public_ips" {
  value = google_compute_address.instance-public-ip.*.address
}

output "instance_private_ips" {
  value = google_compute_instance.instance.*.network_interface.0.network_ip
}

output "instance_names" {
  value = google_compute_instance.instance.*.name
}

output "instance_instance_group" {
  value = google_compute_instance_group.instance-group-unmanaged.*.self_link
}
