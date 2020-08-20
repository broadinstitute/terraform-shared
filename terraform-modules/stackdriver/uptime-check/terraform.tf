
provider "google" {
  alias = "target"
}

provider "vault" {
  address = var.vault_addr
}
