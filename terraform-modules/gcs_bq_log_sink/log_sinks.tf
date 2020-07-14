resource "random_id" "id" {
  byte_length   = 3
}


resource "google_bigquery_dataset" "logs" {
  count       = var.enable_bigquery
  dataset_id  = "${replace(var.project, "-", "_")}_${var.application_name}_${var.owner}_audit_${random_id.id.dec}"
  description = "Audit logs for ${var.application_name} for ${var.owner}"
  location    = "US"

  // 31 days in ms
  default_table_expiration_ms = var.bigquery_retention_days * 24 * 60 * 60 * 1000

  labels = {
    env = var.owner
  }
  depends_on  = [random_id.id]
}

resource "google_bigquery_dataset_access" "access" {
  provivder     =
  dataset_id    = google_bigquery_dataset.logs[0].dataset_id
  role          = "OWNER"
  user_by_email = "${google_logging_project_sink.bigquery-log-sink[0].writer_identity}"
  depends_on    = [google_bigquery_dataset.logs,google_logging_project_sink.bigquery-log-sink]
}

resource "google_logging_project_sink" "bigquery-log-sink" {
  count                  = var.enable_bigquery
  name                   = "${var.application_name}-${var.owner}-bigquery-log-sink${random_id.id.dec}"
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.logs[0].dataset_id}"
  filter                 = var.log_filter
  unique_writer_identity = true
  depends_on  = [google_bigquery_dataset.logs]
}

# grant writer access to bigquery.
resource "google_project_iam_binding" "bigquery-data" {
    count =  var.enable_bigquery
    role   = "roles/bigquery.dataOwner"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink]
}

resource "google_project_iam_binding" "bigquery-admin" {
    count =  var.enable_bigquery
    role   = "roles/bigquery.admin"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink]
}

resource "google_project_iam_binding" "bigquery-log-writer-permisson" {
    count =  var.enable_bigquery
    role   = "roles/logging.configWriter"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink]
}

resource "google_project_iam_binding" "pubsub-publisher-permisson" {
    count =  var.enable_bigquery
    role   = "roles/pubsub.publisher"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink]
}

resource "google_storage_bucket" "logs" {
  count = var.enable_gcs
  name  = "${var.project}_${var.application_name}_${var.owner}_audit${random_id.id.dec}"
  depends_on  = [random_id.id]
}

# Grant service account access to the storage bucket
resource "google_storage_bucket_iam_member" "bucket-log-writer" {
  count  = var.enable_gcs
  bucket = google_storage_bucket.logs[0].name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.bucket-log-sink[0].writer_identity
}

resource "google_logging_project_sink" "bucket-log-sink" {
  count                  = var.enable_gcs
  name                   = "${var.application_name}-${var.owner}-gcs-log-sink${random_id.id.dec}"
  destination            = "storage.googleapis.com/${google_storage_bucket.logs[0].name}"
  filter                 = var.log_filter
  unique_writer_identity = true
  depends_on  = [random_id.id]
}
######

resource "google_pubsub_topic" "pubsub" {
  count   = var.enable_pubsub
  name    = "${var.application_name}-${var.owner}-logs-pubsub${random_id.id.dec}"
  depends_on  = [random_id.id]
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log-writer" {
    role = "roles/logging.configWriter"
    count       = var.enable_pubsub
    members = [
        "${google_logging_project_sink.pubsub-log-sink[0].writer_identity}",
    ]
}

# Our sink; this logs all activity; This requires your SA to have Logging/Logs Configuration Writer
resource "google_logging_project_sink" "pubsub-log-sink" {
  count       = var.enable_pubsub
  name        = "${var.application_name}-${var.owner}-pubsub-log-sink${random_id.id.dec}"
  destination = "pubsub.googleapis.com/projects/${var.project}/topics/${google_pubsub_topic.pubsub[0].name}"
  filter      = var.log_filter
  unique_writer_identity = true
  depends_on  = [random_id.id]
}
