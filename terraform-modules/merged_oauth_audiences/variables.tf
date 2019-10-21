terraform {
  required_version = ">= 0.12"
}

provider "vault" {}

variable "original_audience_secret_path" {type = string}
variable "new_audience_secret_path" {type = string}
variable "values_to_merge" {type = map(string)}
