terraform {
  required_version = ">= 0.12.6"
}

provider "google" {
    alias = "targetdns"
}
