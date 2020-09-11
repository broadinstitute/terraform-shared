output instance-external-ips {
  value = google_compute_instance.runner[*].network_interface.0.access_config.0.nat_ip
}

output instance-names {
  value = google_compute_instance.runner[*].name
}