# Outputs
output "pubsub_writer_identity" {
  value = google_logging_project_sink.pubsub-log-sink.*.writer_identity
}

output "bigquery_writer_identity" {
  value = google_logging_project_sink.bigquery-log-sink.*.writer_identity
}

output "gcs_writer_identity" {
  value = google_logging_project_sink.bucket-log-sink.*.writer_identity
}

output "bucket_name" {
  value = google_storage_bucket.logs.*.name
}

output "pubsub_name" {
  value = google_pubsub_topic.pubsub.*.name
}

output "dataset_id" {
  value = google_bigquery_dataset.logs.*.dataset_id
}

output "dataset_path" {
  value = google_logging_project_sink.bigquery-log-sink.*.destination
}

output "log_filter" {
  value = var.log_filter
}
