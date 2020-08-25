resource "google_compute_ssl_policy" "ssl-policy" {
  provider        = google.target
  count           = var.load_balancer_ssl_policy_create
  name            = var.ssl_policy_name
  profile         = var.load_balancer_ssl_policy_profile
  min_tls_version = var.min_tls_version
}
