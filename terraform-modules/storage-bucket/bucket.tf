terraform {
  required_version = ">= 0.12.6"
}

# This module creates a single bucket

resource "google_storage_bucket" "bucket" {
  count         = length(var.bucket_name)
  name          = var.bucket_name
  provider = google

  location      = var.location
  storage_class = var.storage_class

  versioning {
    enabled = var.versioning
  }
}

# create ACLs

resource "google_storage_bucket_iam_binding" "binding" {
  for_each = var.bindings

  bucket = google_storage_bucket.bucket.name
  role = each.value["role"]
  members = each.value["members"]
  depends_on = [google_storage_bucket.bucket]

}




