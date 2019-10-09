variable "project_name" {}

variable "folder_id" {}

variable "billing_account_id" {}

variable "apis_to_enable" {
   type = list(string)
   default = []
}

variable "service_accounts_to_grant" {
  type = list(object({
    sa_email = string
    sa_roles = list(string)
  }))
  default = []
}

variable "service_accounts_to_create_with_keys" {
  type = list(object({
    sa_name = string
    sa_roles = list(string)
    key_vault_path = string
  }))
  default = []
}

variable "service_accounts_to_create_without_keys" {
  type = list(object({
    sa_name = string
    sa_roles = list(string)
  }))
  default = []
}
