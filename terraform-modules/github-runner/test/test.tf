provider "google" {
  alias   = "broad-gotc-dev"
  project = "broad-gotc-dev"
}

module "test_runner" {
  source = "../"

  providers = {
    google = google.broad-gotc-dev
  }

  # Bucket names containing "google" are globally invalid,
  # used by example here to avoid referencing any foreign data
  vault-role-id-path   = "gs://some-google-bucket/role-id"
  vault-secret-id-path = "gs://some-google-bucket/secret-id"

  # A real value would need to have the token in a `token` field
  github-personal-access-token-path = "secret/dsde/gotc/some/path"

  repo            = "gotc-deploy"
  service-account = "ci-non-prod@broad-gotc-dev.iam.gserviceaccount.com"
}
