
output cloud_nat_ips {
  value = google_compute_address.cloud-nat-address.*.address
}
