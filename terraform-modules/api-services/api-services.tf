
# ServiceUsage API
resource google_project_service serviceusage {
  count    = var.enable_flag ? 1 : 0
  provider = google
  service = "serviceusage.googleapis.com"
  disable_on_destroy = var.destroy
}

# cloudresourcemanager API
resource google_project_service cloudresourcemanager {
  count    = var.enable_flag ? 1 : 0
  provider = google
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = var.destroy

}

resource google_project_service required-services {
  count = var.enable_flag ? length(var.services) : 0
  provider = google
  service = var.services[count.index]
  disable_on_destroy = var.destroy
  depends_on = [
    google_project_service.cloudresourcemanager,
    google_project_service.serviceusage
  ]
}
