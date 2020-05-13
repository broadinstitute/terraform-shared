output "buckets" {
  description = "Bucket resources."
  value       = google_storage_bucket.buckets
}

output "names" {
  description = "Bucket names."
  value       = zipmap(var.buckets_name, slice(google_storage_bucket.buckets[*].name, 0, length(var.buckets_name)))
}

output "urls" {
  description = "Bucket URLs."
  value       = zipmap(var.buckets_name, slice(google_storage_bucket.buckets[*].url, 0, length(var.buckets_name)))
}

output "names_list" {
  description = "List of bucket names."
  value       = google_storage_bucket.buckets[*].name
}

output "urls_list" {
  description = "List of bucket URLs."
  value       = google_storage_bucket.buckets[*].url
}