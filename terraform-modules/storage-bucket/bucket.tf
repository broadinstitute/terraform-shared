terraform {
  required_version = ">= 0.12.6"
}


locals {
  prefix = var.prefix == "" ? "" : join("-", list(var.prefix, lower(var.location), ""))
}

resource "google_storage_bucket" "buckets" {
  count         = length(var.buckets_name)
  name          = "${local.prefix}${lower(element(var.buckets_name, count.index))}"
  provider = google
  project  = var.project_id
  location      = var.location
  storage_class = var.storage_class

  versioning {
    enabled = lookup(
      var.versioning,
      lower(element(var.buckets_name, count.index)),
      false,
    )
  }
}

# create multiple iam bindings (identical) for each projects if required (boolean)
resource "google_storage_bucket_iam_binding" "admins" {
  count  = var.set_admin_roles ? length(var.buckets_name) : 0
  bucket = element(google_storage_bucket.buckets.*.name, count.index)
  role   = "roles/storage.objectAdmin"
  members = var.bucket_admins
}

resource "google_storage_bucket_iam_binding" "viewers" {
  count  = var.set_viewer_roles ? length(var.buckets_name) : 0
  bucket = element(google_storage_bucket.buckets.*.name, count.index)
  role   = "roles/storage.objectViewer"
  members = var.bucket_viewers
}

resource "google_storage_bucket_iam_binding" "legacy-viewers" {
  count  = var.set_legacy_roles ? length(var.buckets_name) : 0
  bucket = element(google_storage_bucket.buckets.*.name, count.index)
  role   = "roles/storage.legacyBucketReader"
  members = var.bucket_legacyviewers
}



