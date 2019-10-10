variable "project_name" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "billing_account_id" {
  type = string
}

variable "apis_to_enable" {
   type = list(string)
   default = []
}

variable "service_accounts_to_create_with_keys" {
  type = list(object({
    sa_name = string
    key_vault_path = string
  }))
  default = []
}

variable "service_accounts_to_create_without_keys" {
  type = list(string)
  default = []
}

variable "service_accounts_to_grant_by_name_and_project" {
  type = list(object({
    sa_name = string
    sa_role = string
    sa_project = string
  }))
  default = []
}

variable "roles_to_grant_by_email_and_type" {
  type = list(object({
    email = string
    role = string
    id_type = string
  }))
  default = []
}
