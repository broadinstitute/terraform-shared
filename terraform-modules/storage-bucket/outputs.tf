output "bucket" {
  description = "Bucket resources."
  value       = var.enable ? google_storage_bucket.bucket : null
}

