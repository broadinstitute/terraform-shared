
resource "google_compute_router" "cloud-nat-router" {
  name       = var.cloud_nat_name == null ? "cloud-nat-${random_id.cloud-nat.hex}" : var.cloud_nat_name
  region     = var.cloud_nat_region
  network    = var.cloud_nat_network
  depends_on = [random_id.cloud-nat]
}


