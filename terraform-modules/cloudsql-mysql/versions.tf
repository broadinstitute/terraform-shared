terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      configuration_aliases = [
        google.target
      ]
    }
  }
  required_version = ">= 1.0.0"
}
