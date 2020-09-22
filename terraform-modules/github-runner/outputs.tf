output instance-external-ips {
  description = "The static public IPs of the runners"
  value       = google_compute_instance.runner[*].network_interface.0.access_config.0.nat_ip
}

output instance-names {
  description = "The names of the runners"
  value       = google_compute_instance.runner[*].name
}
