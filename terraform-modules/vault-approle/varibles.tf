variable "approle" {
#  type = map(object({token_policies = list(string)}))
  type = map(object({ token_policies = list(string), secret_id_num_uses = number, secret_id_ttl = number, token_ttl = number, token_num_uses = number, token_max_ttl = number }))
}

variable "vault_address" {
  type  = string
  default = "https://clotho.broadinstitute.org:8200"
}
