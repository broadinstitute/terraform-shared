resource "google_service_account" "service-accounts-with-keys" {
  count = length(var.service_accounts_to_create_with_keys)
  account_id   = var.service_accounts_to_create_with_keys[count.index].sa_name
  display_name   = var.service_accounts_to_create_with_keys[count.index].sa_name
  project     = google_project.project.name
}

resource "google_service_account" "service-accounts-without-keys" {
  count = length(var.service_accounts_to_create_without_keys)
  account_id   = var.service_accounts_to_create_without_keys[count.index]
  display_name   = var.service_accounts_to_create_without_keys[count.index]
  project     = google_project.project.name
}

resource "google_project_iam_member" "service-accounts-to-grant-by-name-and-project" {
  count = length(var.service_accounts_to_grant_by_name_and_project)
  project     = google_project.project.name
  role    = var.service_accounts_to_grant_by_name_and_project[count.index].sa_role
  member  = "serviceAccount:${var.service_accounts_to_grant_by_name_and_project[count.index].sa_name}@${var.service_accounts_to_grant_by_name_and_project[count.index].sa_project == "" ? google_project.project.name : var.service_accounts_to_grant_by_name_and_project[count.index].sa_project}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "roles-to-grant-by-email-and-type" {
  count = length(var.roles_to_grant_by_email_and_type)
  project     = google_project.project.name
  role    = var.roles_to_grant_by_email_and_type[count.index].role
  member  = "${var.roles_to_grant_by_email_and_type[count.index].id_type == "" ? "serviceAccount" : var.roles_to_grant_by_email_and_type[count.index].id_type}:${var.roles_to_grant_by_email_and_type[count.index].email}"
}

resource "google_service_account_key" "service-accounts-with-keys" {
  count = length(var.service_accounts_to_create_with_keys)
  service_account_id = google_service_account.service-accounts-with-keys[count.index].name
}

provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  count = length(var.service_accounts_to_create_with_keys)
  path = var.service_accounts_to_create_with_keys[count.index].key_vault_path
  data_json = "${base64decode(google_service_account_key.service-accounts-with-keys[count.index].private_key)}"
}
