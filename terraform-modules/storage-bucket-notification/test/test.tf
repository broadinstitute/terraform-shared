provider "google" {
  project = "broad-gotc-dev"
}

module "test_storage_bucket_notification" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "../"

  providers = {
    google = google
  }

  bucket_name = "test-just-a-test"
  topic_name  = "test-just-a-test"
}