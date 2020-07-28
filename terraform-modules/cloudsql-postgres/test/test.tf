provider "google" {
  project = "broad-gotc-dev"
}

module "test_postgres" {
  source = "../"

  providers = {
    google              = google
    google.dns_provider = google
  }

}
