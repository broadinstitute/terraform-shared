terraform {
  required_version = ">= 0.12"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">= 5.0"
    }
  }
}
