provider "google" {
  project = "broad-gotc-dev"
}

module "test_wfl_instance" {
  source = "../"

  providers = {
    google              = google.broad-gotc-dev
    google.dns_provider = google.broad-gotc-dev
  }

  instance_id = "test-just-a-test"

}
