
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

variable "instance_id_label_prefix" {
  type    = string
  default = null
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

  validation {
    condition     = var.gke_name != null
    error_message = "The variable gke_name was null. You MUST provide the name of the cluster."
  }
}

variable "gke_endpoint" {
  description = "The endpoint output from the module that makes the GKE cluster."
  type        = string
  default     = null

  validation {
    condition     = var.gke_endpoint != null
    error_message = "The variable gke_endpoint was null. You MUST provide the endpoint created for the cluster."
  }
}

variable "gke_ca_certificate" {
  description = "The certificate output from the module that makes the GKE cluster."
  type        = string
  default     = null

  validation {
    condition     = var.gke_ca_certificate != null
    error_message = "The variable gke_ca_certificate was null. You MUST provide the certificate created for the cluster."
  }
}

locals {
  labels = {
    app_name = "wfl"
    instance_id = var.instance_id_label_prefix == null ? "${var.instance_id_label_prefix}-${var.instance_id}" : var.instance_id
    app_cluster = var.gke_name
  }
  namespace = "${var.instance_id}-wfl"
}
