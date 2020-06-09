
variable dependencies {
  type        = list
  default     = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

variable "dns_zone" {
  type    = string
  default = null
}

variable "instance_id" {
  type    = string
  default = null

  validation {
    condition     = var.instance_id != null
    error_message = "The variable instance_id was null. You MUST specify value for instance_id."
  }
}

variable "owner" {
  type    = string
  default = null
}

