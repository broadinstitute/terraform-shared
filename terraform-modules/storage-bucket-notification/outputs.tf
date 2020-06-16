output "topic" {
  description = "The PubSub topic."
  value       = google_pubsub_topic.topic
}

output "bucket_notification" {
  description = "The storage bucket notification."
  value       = google_storage_notification.notification
}