resource "random_id" "id" {
  count         = var.enable ? 1 : 0
  byte_length   = 3
  depends_on    = [var.dependencies]
}


resource "google_bigquery_dataset" "logs" {
  count       = local.enable_bigquery ? 1 : 0
  dataset_id  = "${replace(var.project, "-", "_")}_${var.application_name}_${var.owner}_audit_${random_id.id[0].dec}"
  description = "Audit logs for ${var.application_name} for ${var.owner}"
  location    = "US"

  // 31 days in ms
  default_table_expiration_ms = var.bigquery_retention_days * 24 * 60 * 60 * 1000

  labels = {
    env = var.owner
  }
  depends_on  = [random_id.id,var.dependencies]
}

resource "google_bigquery_dataset_access" "access" {
  count         = local.enable_bigquery ? 1 : 0
  dataset_id    = google_bigquery_dataset.logs[0].dataset_id
  role          = "OWNER"
  special_group = "allAuthenticatedUsers"
  depends_on    = [google_bigquery_dataset.logs,google_logging_project_sink.bigquery-log-sink,var.dependencies]
}

resource "google_logging_project_sink" "bigquery-log-sink" {
  count                  = local.enable_bigquery ? 1 : 0
  name                   = "${var.application_name}-${var.owner}-bigquery-log-sink${random_id.id[0].dec}"
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.logs[0].dataset_id}"
  filter                 = var.log_filter
  unique_writer_identity = true
  depends_on  = [google_bigquery_dataset.logs,var.dependencies]
}

# grant writer access to bigquery.
resource "google_project_iam_binding" "bigquery-data" {
    count =  local.enable_bigquery ? 1 : 0
    role   = "roles/bigquery.dataOwner"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink,var.dependencies]
}

resource "google_project_iam_binding" "bigquery-admin" {
    count =  local.enable_bigquery ? 1 : 0
    role   = "roles/bigquery.admin"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink,var.dependencies]
}

resource "google_project_iam_binding" "bigquery-log-writer-permisson" {
    count =  local.enable_bigquery ? 1 : 0
    role   = "roles/logging.configWriter"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink,var.dependencies]
}

resource "google_project_iam_binding" "pubsub-publisher-permisson" {
    count =  local.enable_bigquery ? 1 : 0
    role   = "roles/pubsub.publisher"
    members = [google_logging_project_sink.bigquery-log-sink[0].writer_identity]
    depends_on  = [google_logging_project_sink.bigquery-log-sink,var.dependencies]
}

resource "google_storage_bucket" "logs" {
  count = local.enable_gcs ? 1 : 0
  name  = "${var.project}_${var.application_name}_${var.owner}_audit${random_id.id[0].dec}"
  depends_on  = [random_id.id,var.dependencies]
}

# Grant service account access to the storage bucket
resource "google_storage_bucket_iam_member" "bucket-log-writer" {
  count  = local.enable_gcs ? 1 : 0
  bucket = google_storage_bucket.logs[0].name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.bucket-log-sink[0].writer_identity
  depends_on    = [var.dependencies]
}

resource "google_logging_project_sink" "bucket-log-sink" {
  count                  = local.enable_gcs ? 1 : 0
  name                   = "${var.application_name}-${var.owner}-gcs-log-sink${random_id.id[0].dec}"
  destination            = "storage.googleapis.com/${google_storage_bucket.logs[0].name}"
  filter                 = var.log_filter
  unique_writer_identity = true
  depends_on  = [random_id.id,var.dependencies]
}
######

resource "google_pubsub_topic" "pubsub" {
  count   = local.enable_pubsub ? 1 : 0
  name    = "${var.application_name}-${var.owner}-logs-pubsub${random_id.id[0].dec}"
  depends_on  = [random_id.id,var.dependencies]
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log-writer" {
    role = "roles/logging.configWriter"
    count       = local.enable_pubsub ? 1 : 0
    members = [
        "${google_logging_project_sink.pubsub-log-sink[0].writer_identity}",
    ]
    depends_on    = [var.dependencies]
}

# Our sink; this logs all activity; This requires your SA to have Logging/Logs Configuration Writer
resource "google_logging_project_sink" "pubsub-log-sink" {
  count       = local.enable_pubsub ? 1 : 0
  name        = "${var.application_name}-${var.owner}-pubsub-log-sink${random_id.id[0].dec}"
  destination = "pubsub.googleapis.com/projects/${var.project}/topics/${google_pubsub_topic.pubsub[0].name}"
  filter      = var.log_filter
  unique_writer_identity = true
  depends_on  = [random_id.id,var.dependencies]
}
