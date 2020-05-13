variable "project_id" {
  description = "The name of the project to create the bucket in."
  type = string
}

variable "prefix" {
  description = "The unique prefix to your project - usually the name of the project"
  type = string
}

variable "buckets_name" {
  description = "The name of the bucket."
  type = list(string)
}

variable "versioning" {
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
  type        = map
  default     = {}
}

variable "location" {
  description = "The location of the bucket."
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = "MULTI_REGIONAL"
}

variable "bucket_admins" {
  description = "The list of admin users to grant permissions on the bucket."
  type = list(string)
  default = []
}

variable "bucket_viewers" {
  description = "The list of viewers users to grant permissions on the bucket."
  type = list(string)
  default = []
}

variable "bucket_legacyviewers" {
  description = "The list of legacy users to grant permissions on the bucket."
  type = list(string)
  default = []
}

variable "set_admin_roles" {
  description = "Grant roles/storage.objectAdmin role to admins and bucket_admins."
  type        = bool
  default     = false
}

variable "set_legacy_roles" {
  description = "Grant roles/storage.legacyBucketReader role to Legacy viewers and bucket_Legacy_viewers."
  type        = bool
  default     = false
}

variable "set_viewer_roles" {
  description = "Grant roles/storage.objectViewer role to viewers and bucket_viewers."
  type        = bool
  default     = false
}

