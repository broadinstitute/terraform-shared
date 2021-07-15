provider "google" {
  project = "broad-dsde-dev"
  region  = "us-central1"
}

provider "vault" {
  address = "https://clotho.broadinstitute.org:8200/"
}