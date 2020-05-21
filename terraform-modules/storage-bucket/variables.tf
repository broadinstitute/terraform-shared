variable "bucket_name" {
  description = "The name of the bucket."
  type = string
}

variable "versioning" {
  description = "Optional boolean to define versioning of the bucket. defaults to false."
  type        = string
  default     = false
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

# ACL names and members
variable "bindings" {
  type = map(object({role = string, members = list(string)}))
}
