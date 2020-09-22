variable "vault-role-id-path" {
  type        = string
  description = "A `gs://...` path that the instance's service account can read the vault role ID from"

  validation {
    condition     = length(regexall("^gs://.*", var.vault-role-id-path)) == 1
    error_message = "The path to a vault role ID must be given as a `gs://...` path."
  }
}

variable "vault-secret-id-path" {
  type        = string
  description = "A `gs://...` path that the instance's service account can read the vault secret ID from"

  validation {
    condition     = length(regexall("^gs://.*", var.vault-secret-id-path)) == 1
    error_message = "The path to a vault secret ID must be given as a `gs://...` path."
  }
}

variable "vault-server" {
  type        = string
  description = "The address of the vault server"
  default     = "https://clotho.broadinstitute.org:8200"
}

variable "github-personal-access-token-path" {
  type        = string
  description = "A `secret/...` path within Vault to use to get a GH PAT to register the runner"

  validation {
    condition     = length(regexall("^secret/.*", var.github-personal-access-token-path)) == 1
    error_message = "The path to a Vault Secret ID must be given as a `gs://...` path."
  }
}

variable "repo" {
  type        = string
  description = "The name of the GitHub repo to be a runner for, without the owner prefix"

  validation {
    condition     = length(regexall("^[^/]*$", var.repo)) == 1
    error_message = "The repo must not include the owner."
  }
}

variable "runner-labels" {
  type        = set(string)
  description = "Labels to put on the runner in GitHub"
  default     = []
}

variable "service-account" {
  type        = string
  description = "The email of the service account to use on the instance"

  validation {
    condition     = length(regexall("^[^@]+@[^@]+$", var.service-account)) == 1
    error_message = "The service account must be given as a full email."
  }
}

variable "service-account-scopes" {
  type        = list(string)
  description = "Scopes for the service account to have on the instance"
  default     = ["cloud-platform", "userinfo-email", "https://www.googleapis.com/auth/userinfo.profile"]
}

variable "actions-user" {
  type        = string
  description = "The username of the non-root to create to run actions as"
  default     = "actions"
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

variable "runners" {
  type        = number
  description = "The number of individual instances to provision"
  default     = 1
}
