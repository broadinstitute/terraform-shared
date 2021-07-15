terraform {
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
