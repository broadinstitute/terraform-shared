provider "google" {
  project = "broad-gotc-dev"
}

module "test_wfl_instance" {
  source = "../"

  providers = {
    google              = google
    google.dns_provider = google
  }

  instance_id = "test-just-a-test"

  gke_name           = "none"
  gke_endpoint       = "none"
  gke_ca_certificate = "none"
}
