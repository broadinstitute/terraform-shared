variable "approle" {
  type = map(object({token_policies = list(string)}))
}

variable "vault_address" {
  type  = string
  default = "https://clotho.broadinstitute.org:8200"
}
