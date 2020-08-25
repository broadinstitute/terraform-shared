resource "google_compute_security_policy" "policy" {
  provider = google.target
  count = length(var.load_balancer_rules) != 0 ? 1 : 0

  name = "${var.load_balancer_name}-policy"

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default deny rule"
  }

  dynamic "rule" {
    for_each = var.load_balancer_rules
    content {
      action   = rule.value["action"]
      priority = rule.value["priority"]
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = rule.value["ip_ranges"]
        }
      }
      description = rule.value["description"]
    }
  }
}
