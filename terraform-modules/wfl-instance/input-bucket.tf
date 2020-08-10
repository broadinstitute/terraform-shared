module "input-bucket" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/storage-bucket?ref=storage-bucket-0.0.3"

  providers = {
    google = google.storage_provider
  }

  # Create one bucket and set ACLs

  bucket_name     = var.input_bucket_name != null ? var.input_bucket_name : "${var.instance_id}-wfl-inputs"
  versioning      = var.input_bucket_versioning
  bindings        = var.input_bucket_bindings
  lifecycle_rules = var.input_bucket_lifecycle_rules
  labels          = local.labels

}
