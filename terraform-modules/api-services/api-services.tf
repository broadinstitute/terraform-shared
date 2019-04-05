# ServiceUsage API
resource "google_project_service" "serviceusage" {
  provider = "${var.provider}"
  project = "${var.project}"
  service = "serviceusage.googleapis.com"
}
# cloudresourcemanager API
resource "google_project_service" "cloudresourcemanager" {
  provider = "${var.provider}"
  project = "${var.project}"
  service = "cloudresourcemanager.googleapis.com"
}
resource "google_project_service" "required-services" {
  provider = "${var.provider}"
  project = "${var.project}"
  count = "${length(var.services)}"
  service = "${element(var.services, count.index)}"
  depends_on = ["google_project_service.cloudresourcemanager","google_project_service.serviceusage"]
}
