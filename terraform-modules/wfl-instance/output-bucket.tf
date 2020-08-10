module "output-bucket" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/storage-bucket?ref=storage-bucket-0.0.3"

  providers = {
    google = google.storage_provider
  }

  # Create one bucket and set ACLs

  bucket_name     = var.output_bucket_name != null ? var.output_bucket_name : "${var.instance_id}-wfl-outputs"
  versioning      = var.output_bucket_versioning
  bindings        = var.output_bucket_bindings
  lifecycle_rules = var.output_bucket_lifecycle_rules
  labels          = local.labels

}
