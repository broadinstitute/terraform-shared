resource "google_compute_ssl_policy" "tls12-ssl-policy" {
  provider = "google.target"
  count = "${var.enable_flag}"
  name            = "tls12-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}
