terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 3.9"
      configuration_aliases = [
        google.target
      ]
    }
  }
  required_version = ">= 1.0.0"
}
