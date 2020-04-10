variable "github_team" {
  type = map(object({policies = list(string)}))
}

variable "vault_address" {
  type  = string
  default = "https://clotho.broadinstitute.org:8200"
}
