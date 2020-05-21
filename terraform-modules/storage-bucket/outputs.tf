output "bucket" {
  description = "Bucket resources."
  value       = google_storage_bucket.bucket
}

output "name" {
  description = "Bucket name."
  value       = google_storage_bucket.bucket.name
}

output "url" {
  description = "Bucket URLs."
  value       = google_storage_bucket.bucket.url
}
