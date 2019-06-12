
output "instance_public_ips" {
  value = "${google_compute_address.instance-public-ip.*.address}"
}

output "instance_instance_group" {
  value = "${google_compute_instance_group.instance-group-unmanaged.*.self_link}"
}

