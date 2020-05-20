
resource "random_id" "cloud-nat" {
  byte_length = 8
}

locals {
  cloud_nat_default_name = "cloud-nat-${random_id.cloud-nat.hex}"
}
