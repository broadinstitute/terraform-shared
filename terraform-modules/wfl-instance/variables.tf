
variable "dns_zone" {
  type    = string
  default = null
}

variable "instance_id" {
  type    = string
  default = null
}

variable "instance_id_label_prefix" {
  type    = string
  default = ""
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

variable "gke_name" {
  description = "The name output from the module that makes the GKE cluster."
  type        = string
  default     = null
}

variable "gke_endpoint" {
  description = "The endpoint output from the module that makes the GKE cluster."
  type        = string
  default     = null
}

variable "gke_ca_certificate" {
  description = "The certificate output from the module that makes the GKE cluster."
  type        = string
  default     = null
}

locals {
  labels = {
    app_name    = "wfl"
    instance_id = var.instance_id_label_prefix == null ? "${var.instance_id_label_prefix}-${var.instance_id}" : var.instance_id
    app_cluster = var.gke_name
  }
  namespace = "${var.instance_id}-wfl"
}
