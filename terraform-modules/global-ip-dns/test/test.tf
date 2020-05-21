provider "google" {
  project = "broad-gotc-dev"
}

module "test_auth_proxy" {
  source              = "../"

  providers = { 
    google = google
    google.dns_provider = google
  }
  auth_proxy_dns_name = "test-auth-proxy"
  auth_proxy_dns_zone = "gotc-dev"
}
