
resource "random_id" "rule-id" {
  byte_length = 8
}

resource "google_compute_firewall" "firewall-rule" {
  provider       = google

  name           = length(var.firewall_rule_name) == 0 ? "firewall-rule-${random_id.rule-id.hex}" : var.firewall_rule_name
  network        = var.firewall_rule_network
  description    = "Firewall rulle created by module"

  enable_logging = var.firewall_rule_logging

  allow {
    protocol = var.firewall_rule_protocol
    ports    = var.firewall_rule_ports
  }

  target_tags   = var.firewall_rule_target_tags
  source_ranges = var.firewall_rule_source_ranges
}

