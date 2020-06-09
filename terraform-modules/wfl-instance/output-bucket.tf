module "output-bucket" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/storage-bucket?ref=storage-bucket-0.0.1"

  providers = {
    google = google
  }

  # Create one bucket and set ACLs
  bucket_name = "${var.instance_id}-wfl-outputs"
  versioning  = false
  bindings = {
    storage_admins = {
      role = "roles/storage.admin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    admins = {
      role = "roles/storage.objectAdmin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    viewers = {
      role = "roles/storage.objectViewer"
      members = [
        "serviceAccount:wfl-non-prod@broad-gotc-dev.iam.gserviceaccount.com",
      ]
    },
    viewers_legacy = {
      role = "roles/storage.legacyBucketReader"
      members = [
        "serviceAccount:wfl-non-prod@broad-gotc-dev.iam.gserviceaccount.com",
      ]
    }
  }
}
