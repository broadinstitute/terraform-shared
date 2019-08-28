resource "google_project" "google-project" {
  provider              = "google.target"
  count                 = "${var.enable_flag}"
  name                  = "${var.google_project_name}"
  project_id            = "${var.google_project_id}"
  folder_id             = "${google_folder.folder.name}"
  auto_create_network   = false
}

resource "google_folder" "folder" {
  provider              = "google.target"
  count                 = "${var.enable_flag}"
  display_name          = "${var.google_project_folder_display_name}"
  parent                = "organizations/${var.google_project_folder_parent}"
}

