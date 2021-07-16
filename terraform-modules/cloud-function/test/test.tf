module "test_cloud_function" {
  # Change the trailing ref to adjust version
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloud-function?ref=cloud-function-1.0.0"

  providers = {
    google = google
    vault  = vault
  }

  function_name        = "my-function"
  function_runtime     = "python39"
  function_entry_point = "my_python_function"

  # Supply function_event_trigger or function_trigger_http
  function_event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource   = "projects/broad-dsde-dev/topics/my-topic"
    retry      = true
  }

  # Supply function_source_archive or function_source_repository
  function_source_archive = {
    archive_bucket = "gs://my-bucket"
    archive_object = "my-code.zip"
  }

  # Optionally, specify secrets to be synced from Vault
  function_vault_secrets = {
    "my_api_key" = {
      vault_secret_path       = "secret/path/in/vault"
      vault_secret_json_key   = "my-api-key"
      env_var_for_secret_name = "MY_API_KEY_NAME"
    }
  }

  # Optionally, specify Cloud Monitoring Channels to be notified on failure
  monitoring_channel_names = [
    "#my-team-channel"
  ]
}
