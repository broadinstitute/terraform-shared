output "function_service_account_email" {
  value       = google_cloudfunctions_function.function.service_account_email
  description = "Email of the service account used for the cloud function"
}

output "function_https_trigger_url" {
  value       = google_cloudfunctions_function.function.https_trigger_url
  description = <<-EOT
    When `function_trigger_http` is true, this is the URL of the cloud function.

    The URL of the cloud function will be the following:
    `https://{google_region}-{google_project}.cloudfunctions.net/{function_name}`.
  EOT
}
