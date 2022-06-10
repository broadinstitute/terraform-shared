module "enable-services" {
  source      = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-1.0.0"
  project     = google_project.project.name
  services    = var.apis_to_enable
}
