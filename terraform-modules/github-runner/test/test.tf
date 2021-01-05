provider "google" {
  alias   = "broad-gotc-dev"
  project = "broad-gotc-dev"
}

module "test_runner" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/github-runner?ref=github-runner-0.2.1"

  providers = {
    google = google.broad-gotc-dev
  }

  # SA for both getting the Vault IDs below and for anything else needed
  # within actions (including broadinstitute Docker)
  service-account = "ci-non-prod@broad-gotc-dev.iam.gserviceaccount.com"

  # Vault access both for getting the GitHub token below and for anything else
  # needed within actions
  vault-role-id-path   = "gs://some-google-bucket/role-id"
  vault-secret-id-path = "gs://some-google-bucket/secret-id"
  # Buckets containing "google" are globally invalid, so we aren't referencing
  # anything real here

  # Needs to have the token in a `token` field and must at least grant
  # admin access to the target repo
  github-personal-access-token-path = "secret/dsde/gotc/some/path"

  # Must be within broadinstitute's org and should be private
  repo = "gotc-deploy"
}