
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

variable "input_bucket_name" {
  type    = string
  default = null
}

variable "input_bucket_versioning" {
  type    = bool
  default = false
}

# Setting default to support non-prod installatinos
variable "input_bucket_bindings" {
  type = map(object({ role = string, members = list(string) }))
  default = {
    storage_admins = {
      role = "roles/storage.admin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    admins = {
      role = "roles/storage.objectAdmin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    viewers = {
      role = "roles/storage.objectViewer"
      members = [
        "serviceAccount:wfl-non-prod@broad-gotc-dev.iam.gserviceaccount.com",
      ]
    },
    viewers_legacy = {
      role = "roles/storage.legacyBucketReader"
      members = [
        "serviceAccount:wfl-non-prod@broad-gotc-dev.iam.gserviceaccount.com",
      ]
    }
  }
}

variable "input_bucket_lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type        = list(object({ action = any, condition = any }))
  default     = []
}

variable "output_bucket_name" {
  type    = string
  default = null
}

variable "output_bucket_versioning" {
  type    = bool
  default = false
}

# Setting default to support non-prod installatinos
variable "output_bucket_bindings" {
  type = map(object({ role = string, members = list(string) }))
  default = {
    storage_admins = {
      role = "roles/storage.admin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    admins = {
      role = "roles/storage.objectAdmin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    viewers = {
      role = "roles/storage.objectViewer"
      members = [
        "serviceAccount:wfl-non-prod@broad-gotc-dev.iam.gserviceaccount.com",
      ]
    },
    viewers_legacy = {
      role = "roles/storage.legacyBucketReader"
      members = [
        "serviceAccount:wfl-non-prod@broad-gotc-dev.iam.gserviceaccount.com",
      ]
    }
  }
}

variable "output_bucket_lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type        = list(object({ action = any, condition = any }))
  default     = []
}

locals {
  labels = {
    app_name = "wfl"
    instance_id = var.instance_id
  }
}