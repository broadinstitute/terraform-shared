
resource "google_compute_router_nat" "nat_manual" {
  name       = var.cloud_nat_name == null ? "cloud-nat-${random_id.cloud-nat.hex}" : var.cloud_nat_name
  router     = google_compute_router.cloud-nat-router.name
  region     = google_compute_router.cloud-nat-router.region
  depends_on = [random_id.cloud-nat, google_compute_address.cloud-nat-address, google_compute_router.cloud-nat-router]

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.cloud-nat-address.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = var.cloud_nat_subnetwork == null ? var.cloud_nat_network : var.cloud_nat_subnetwork
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}
