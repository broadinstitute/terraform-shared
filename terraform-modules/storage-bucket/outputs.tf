output "buckets" {
  description = "Bucket resources."
  value       = google_storage_bucket.bucket
}

output "names" {
  description = "Bucket names."
  value       = zipmap(var.bucket_name, slice(google_storage_bucket.bucket[*].name, 0, length(var.bucket_name)))
}

output "urls" {
  description = "Bucket URLs."
  value       = zipmap(var.bucket_name, slice(google_storage_bucket.bucket[*].url, 0, length(var.bucket_name)))
}

output "names_list" {
  description = "List of bucket names."
  value       = google_storage_bucket.bucket[*].name
}

output "urls_list" {
  description = "List of bucket URLs."
  value       = google_storage_bucket.bucket[*].url
}