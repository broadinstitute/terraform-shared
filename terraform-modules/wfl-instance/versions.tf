terraform {
  required_version = ">= 0.12.20"
  experiments      = [variable_validation]

  required_providers {
    google      = ">= 3.2.0"
    google-beta = ">= 3.2.0"
    random      = ">= 2.2"
  }
}
