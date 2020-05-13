resource "google_compute_security_policy" "policy" {
  name = "broad-cloud-armor"

  # only 5 cidrs allowed per rule
  rule {
    action   = "allow"
    priority = "0"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = var.broad_range_cidrs1
      }
    }
  }
  # only 5 cidrs allowed per rule
  rule {
    action   = "allow"
    priority = "1"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = var.broad_range_cidrs2
      }
    }
  }
  # only 5 cidrs allowed per rule
  rule {
    action   = "allow"
    priority = "2"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = var.broad_range_cidrs3
      }
    }
  }

  rule {
    action      = "deny(403)"
    priority    = "2147483647"
    description = "Default rule: deny all"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
