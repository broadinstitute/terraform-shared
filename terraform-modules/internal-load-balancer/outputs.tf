
output "load_balancer_ip" {
  value = "${google_compute_forwarding_rule.load-balancer-internal-lb-forwarding-rule.*.ip_address}"
}

