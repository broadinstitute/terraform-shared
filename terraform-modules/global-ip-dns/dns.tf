# data google_project project {}

# Public IP Address
resource "google_compute_global_address" "global_ip" {
  provider   = google
  name       = "${var.auth_proxy_dns_name}-global-ip"
  ip_version = "IPV4"
}

module "dns-set" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=ra_master_remove_experimental_validations"
  providers = {
    google = google.dns_provider
  }

  target_dns_zone_name = var.auth_proxy_dns_zone
  records              = local.records
}
