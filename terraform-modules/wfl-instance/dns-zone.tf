

data "google_dns_managed_zone" "dns_zone" {
  provider = google.dns_provider
  name     = var.dns_zone
}
