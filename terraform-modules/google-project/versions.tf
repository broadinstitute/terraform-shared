terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      configuration_aliases = [
        google.target
      ]
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
  required_version = ">= 1.0.0"
}
