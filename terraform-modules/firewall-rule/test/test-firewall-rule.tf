
/* 
* Test firewall_rule module
*/

module "test-firewall-rule" {
  source = "../"

  firewall_rule_name          = "test-rule"
  firewall_rule_source_ranges = ["192.168.1.1/32"]
  firewall_rule_target_tags   = ["test-target-firewall-rule"]
  firewall_rule_ports         = ["443", "22"]
}
