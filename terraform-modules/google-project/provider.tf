required_providers {
  google = {
    source = "hashicorp/google"
    configuration_aliases = [
      target,
    ]
  }
  vault = {
    source = "hashicorp/vault"
  }
}
