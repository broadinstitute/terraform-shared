terraform {
  required_version = ">= 0.12.19"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.65.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.8.0"
    }
  }
}
