resource "google_project_service" "enable_secretmanager" {
  count              = length(var.function_vault_secrets) > 0 ? 1 : 0
  project            = var.google_project
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

data "vault_generic_secret" "vault_secret" {
  for_each = var.function_vault_secrets
  path     = each.value["vault_secret_path"]
}

resource "google_secret_manager_secret" "secret_manager_secret" {
  for_each   = var.function_vault_secrets
  depends_on = [google_project_service.enable_secretmanager]
  project    = var.google_project
  secret_id  = "${var.function_name}-${each.value["vault_secret_json_key"]}"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_manager_secret_version" {
  for_each    = var.function_vault_secrets
  secret      = google_secret_manager_secret.secret_manager_secret[each.key].id
  secret_data = data.vault_generic_secret.vault_secret[each.key].data[each.value["vault_secret_json_key"]]
}

resource "google_secret_manager_secret_iam_member" "function_sa_access" {
  for_each  = var.function_vault_secrets
  project   = var.google_project
  secret_id = google_secret_manager_secret.secret_manager_secret[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_cloudfunctions_function.function.service_account_email}"
}
