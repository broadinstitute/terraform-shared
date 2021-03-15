provider "google" {
  project = "broad-gotc-dev"
}

module "test_postgres" {
  source = "../"

  database_flags = {
    max_connections = 100
  }

  providers = {
    google              = google
    google.dns_provider = google
  }

}
