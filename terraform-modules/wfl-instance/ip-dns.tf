module "ip-dns" {

  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/global-ip-dns?ref=global-ip-dns-0.2.0"

  providers = {
    google              = google
    google.dns_provider = google.dns_provider
  }

  auth_proxy_dns_name = "${var.instance_id}-wfl"
  auth_proxy_dns_zone = var.dns_zone
}

