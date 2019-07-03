resource "google_compute_ssl_policy" "ssl-policy" {
  provider        = "google.target"
  count           = "${var.enable_flag}"
  name            = "${var.ssl_policy_name}"
  profile         = "MODERN"
  min_tls_version = "${var.min_tls_version}"
}
