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

  depends_on_cluster = "none"
  cluster_name       = "No cluster here"
  cluster_location   = "The North Pole"
}
