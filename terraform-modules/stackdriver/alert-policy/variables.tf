# Required Variables

variable "policy_name" {
  type = string
  description = "Display name to be associated with a particular alerting policy"
}

variable "condition_combine_method" {
  type = string
  description = "logic to trigger the alert when multiple conditions are present only 'AND' and 'OR' are valid arguments"
}


