resource "random_id" "ssl_certificate_id" {
  byte_length = 4
  prefix      = "ssl-certificate-"
}


resource "google_compute_ssl_certificate" "ssl-certificate" {
  provider    = google

  name        = var.ssl_certificate_name == null ? random_id.ssl_certificate_id.hex : var.ssl_certificate_name
  private_key = var.ssl_certificate_key
  certificate = var.ssl_certificate_cert

}


