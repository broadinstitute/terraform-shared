
# ServiceUsage API
resource "google_project_service" "serviceusage" {
  count    = "${var.enable_flag}"
  provider = "google.target"
  project = "${var.project}"
  service = "serviceusage.googleapis.com"
  disable_on_destroy = "${var.destroy}"
}
# cloudresourcemanager API
resource "google_project_service" "cloudresourcemanager" {
  count    = "${var.enable_flag}"
  provider = "google.target"
  project = "${var.project}"
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = "${var.destroy}"
}
resource "google_project_service" "required-services" {
  provider = "google.target"
  project = "${var.project}"
  count = "${var.enable_flag == "1"?length(var.services):0}"
  service = "${element(var.services, count.index)}"
  disable_on_destroy = "${var.destroy}"
  depends_on = ["google_project_service.cloudresourcemanager","google_project_service.serviceusage"]
}
