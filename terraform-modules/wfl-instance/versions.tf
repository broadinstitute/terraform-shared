terraform {
  required_version = ">= 0.13.6"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 3.55.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">= 3.55.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0.1"
    }
  }
}
