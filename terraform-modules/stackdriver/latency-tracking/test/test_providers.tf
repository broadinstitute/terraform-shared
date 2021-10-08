# This file just contains stubs, necessary for test.tf to pass validation

# Does not need auth for validation
provider "google" {
  project = "broad-dsde-dev"
  region  = "us-central1"
}
