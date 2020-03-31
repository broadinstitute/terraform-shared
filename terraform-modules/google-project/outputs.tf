output "project_number" {
  value = google_project.project.number
}

output "project_name" {
  value = google_project.project.name
}

output "service_accounts_with_keys" {
  value = [google_service_account.service-accounts-with-keys.*.email]
}

output "service_accounts_without_keys" {
  value = [google_service_account.service-accounts-without-keys.*.email]
}
