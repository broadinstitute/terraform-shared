module "enable-services" {
  source      = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-1.0.0"
  
  providers = {
    google = google
  }

  services    = [
    "compute.googleapis.com"
  ]
}
