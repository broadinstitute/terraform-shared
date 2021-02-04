# This module creates a single bucket

resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  provider = google

  location      = var.location
  storage_class = var.storage_class

  versioning {
    enabled = var.versioning
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : [var.logging]
    content {
      log_bucket        = var.logging.log_bucket
      log_object_prefix = var.logging.log_object_prefix
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        created_before        = lookup(lifecycle_rule.value.condition, "storage_class", null)
        with_state            = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_storage_class = lookup(lifecycle_rule.value.condition, "matches_storage_class", null)
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
      }
    }
  }

  labels = var.labels
}

# create ACLs

resource "google_storage_bucket_iam_binding" "binding" {
  for_each = var.bindings

  bucket     = google_storage_bucket.bucket.name
  role       = each.value["role"]
  members    = each.value["members"]
  depends_on = [google_storage_bucket.bucket]

}




