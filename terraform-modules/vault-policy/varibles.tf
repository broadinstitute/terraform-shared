variable "policy" {
  type = map(object({path = string, capabilities = list(string)}))
}

variable "vault_address" {
  type  = string
  default = "https://clotho.broadinstitute.org:8200"
}
