module "enable-services" {
  source      = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=hf_api_service_update"
  
  providers = {
    google = google
  }

  services    = [
    "compute.googleapis.com"
  ]
}
