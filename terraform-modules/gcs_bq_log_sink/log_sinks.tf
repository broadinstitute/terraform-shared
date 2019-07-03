resource "google_bigquery_dataset" "logs" {
  count =  "${var.enable_bigquery}"
  dataset_id                  = "${replace(var.project, "-", "_")}_${var.application_name}_${var.owner}_audit${var.nonce != "" ? "_${var.nonce}" : ""}"
  description                 = "Audit logs for ${var.application_name} for ${var.owner}"
  location                    = "US"
  // 31 days in ms
  default_table_expiration_ms = "${var.bigquery_retention_days * 24 * 60 * 60 * 1000}"

  labels = {
    env = "${var.owner}"
  }
  access {
    role           = "OWNER"
    special_group = "projectOwners"
  }
  access {
    role           = "WRITER"
    user_by_email = "${element(split(":", google_logging_project_sink.bigquery-log-sink.writer_identity), 1)}"
  }
}

resource "google_logging_project_sink" "bigquery-log-sink" {
  count =  "${var.enable_bigquery}"
  name = "${var.application_name}-${var.owner}-bigquery-log-sink${var.nonce != "" ? "_${var.nonce}" : ""}"
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/${replace(var.project, "-", "_")}_${var.application_name}_${var.owner}_audit"
  filter = "${var.log_filter}"
  unique_writer_identity = true
}

resource "google_storage_bucket" "logs" {
  count =  "${var.enable_gcs}"
  name     = "${var.project}_${var.application_name}_${var.owner}_audit${var.nonce != "" ? "_${var.nonce}" : ""}"
}

# Grant service account access to the storage bucket
resource "google_storage_bucket_iam_member" "bucket-log-writer" {
  count =  "${var.enable_gcs}"
  bucket = "${google_storage_bucket.logs.name}"
  role   = "roles/storage.objectCreator"
  member = "${google_logging_project_sink.bucket-log-sink.writer_identity}"
}

resource "google_logging_project_sink" "bucket-log-sink" {
  count =  "${var.enable_gcs}"
  name = "${var.application_name}-${var.owner}-gcs-log-sink${var.nonce != "" ? "_${var.nonce}" : ""}"
  destination = "storage.googleapis.com/${google_storage_bucket.logs.name}"
  filter = "${var.log_filter}"
  unique_writer_identity = true
}

output "bigquery_writer_identity" {
  value = "${google_logging_project_sink.bigquery-log-sink.*.writer_identity}"
}

output "gcs_writer_identity" {
  value = "${google_logging_project_sink.bucket-log-sink.*.writer_identity}"
}

output "bucket_name" {
  value = "${google_storage_bucket.logs.*.name}"
}

output "dataset_id" {
  value = "${google_bigquery_dataset.logs.*.dataset_id}"
}

output "dataset_path" {
  value = "bigquery.googleapis.com/projects/${var.project}/datasets/${replace(var.project, "-", "_")}_${var.application_name}_${var.owner}_audit"
}

output "log_filter" {
  value = "${var.log_filter}"
}