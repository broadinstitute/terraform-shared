resource "google_project" "project" {
  provider = "google.target"
  name                  = "${var.project_name}"
  project_id            = "${var.project_name}"
  billing_account       = "${var.billing_account_id}"
  folder_id             = "${var.folder_id}"
  auto_create_network   = false
}
