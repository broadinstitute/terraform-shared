variable "vault-role-id-path" {
  type        = string
  description = "A `gs://...` path that the instance's service account can read the vault role ID from"
}

variable "vault-secret-id-path" {
  type        = string
  description = "A `gs://...` path that the instance's service account can read the vault secret ID from"
}

variable "github-personal-access-token-path" {
  type        = string
  description = "A `secret/...` path within Vault to use to get a GH PAT to register the runner"
}

variable "repo" {
  type        = string
  description = "The name of the GitHub repo to be a runner for, without the owner prefix"
}

variable "service-account" {
  type        = string
  description = "The email of the service account to use on the instance"
}

variable "zone" {
  type        = string
  description = "The zone to provision the GCE instance in"
  default     = "us-central1-a"
}

variable "machine-type" {
  type        = string
  description = "The type of GCE instance to provision"
  default     = "n1-standard-1"
}

variable "boot-disk-size" {
  type        = string
  description = "The size of the GCE instance boot disk in gigabytes"
  default     = 10
}

variable "count" {
  type        = number
  description = "The number of individual instances to provision"
  default     = 1
}
