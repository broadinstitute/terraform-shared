
resource "google_compute_address" "cloud-nat-address" {
  provider   = google-beta
  count      = var.cloud_nat_num_ips
  name       = var.cloud_nat_name == null ? "cloud-nat-${random_id.cloud-nat.hex}-${count.index}" : "${var.cloud_nat_name}-${count.index}"
  region     = var.cloud_nat_region
  labels     = var.cloud_nat_labels
  depends_on = [random_id.cloud-nat]
}
