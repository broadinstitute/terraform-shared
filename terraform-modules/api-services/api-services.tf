# ServiceUsage API
resource "google_project_service" "serviceusage" {
  provider = "google.target"
  project = "${var.project}"
  service = "serviceusage.googleapis.com"
  disable_on_destroy = "${var.destroy}"
}
# cloudresourcemanager API
resource "google_project_service" "cloudresourcemanager" {
  provider = "google.target"
  project = "${var.project}"
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = "${var.destroy}"
}
resource "google_project_service" "required-services" {
  provider = "google.target"
  project = "${var.project}"
  count = "${length(var.services)}"
  service = "${element(var.services, count.index)}"
  disable_on_destroy = "${var.destroy}"
  depends_on = ["google_project_service.cloudresourcemanager","google_project_service.serviceusage"]
}
