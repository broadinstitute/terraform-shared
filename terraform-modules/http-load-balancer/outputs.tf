output "load_balancer_public_ip" {
  value = google_compute_global_address.load-balancer-pub-ip.*.address
}
