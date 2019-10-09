resource "google_service_account" "service-accounts-with-keys" {
  count = length(var.service_accounts_to_create_with_keys)
  account_id   = var.service_accounts_to_create_with_keys[count.index].sa_name
  display_name   = var.service_accounts_to_create_with_keys[count.index].sa_name
  project     = google_project.project.name
}

resource "google_project_iam_member" "service-accounts-with-keys" {
  count = length(var.service_accounts_to_create_with_keys)
  project     = google_project.project.name
  role    = var.service_accounts_to_create_with_keys[count.index].sa_roles
  member  = "serviceAccount:${google_service_account.service-accounts-with-keys[count.index].email}"
}

resource "google_service_account_key" "service-accounts-with-keys" {
  count = length(var.service_accounts_to_create_with_keys)
  service_account_id = var.service_accounts_to_create_with_keys[count.index].sa_name
}

provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  count = length(var.service_accounts_to_create_with_keys)
  path = var.service_accounts_to_create_with_keys[count.index].key_vault_path
  data_json = "${base64decode(google_service_account_key.service-accounts-with-keys[count.index].private_key)}"
}
