# Does not need auth for validation
provider "google" {
  project = "broad-dsde-dev"
  region  = "us-central1"
}

# Expects VAULT_ADDR in environment, does not need auth for validation
#   (Very old Terraform seems to be finnicky with reading an address
#   provided literally to the provider during validation--this is only
#   a quirk for running validation in this repo for old versions of
#   Terraform and is not an issue for normal use cases)
provider "vault" {
}