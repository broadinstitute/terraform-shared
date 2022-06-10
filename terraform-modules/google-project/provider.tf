terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      configuration_aliases = [
        google.target,
        target
      ]
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}
