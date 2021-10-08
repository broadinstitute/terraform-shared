# This file just contains stubs, necessary for test.tf to pass validation

terraform {
  required_version = ">= 0.15"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.65.0"
    }
  }
}
