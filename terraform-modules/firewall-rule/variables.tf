
# module wide vars

variable "firewall_rule_name" {
  default     = ""
  description = "name of firewall rule"
}

variable "firewall_rule_network" {
  default     = "app-network"
  description = "network name of firewall rule."
}

variable "firewall_rule_protocol" {
  default     = "TCP"
  description = "The zone where instances will be created"
}

variable "firewall_rule_source_ranges" {
  type        = list(string)
  default     = []
  description = "List of source IPs in CIDR format"

  validation {
    condition     = length(var.firewall_rule_source_ranges) != 0
    error_message = "The variable firewall_rule_source_ranges must be a non-empty list."
  }
}

variable "firewall_rule_target_tags" {
  type        = list(string)
  default     = []
  description = "list of target tags that firewall will be applied to"
}

variable "firewall_rule_logging" {
  type        = bool
  default     = false
  description = "Enable firewall rule logging to stackdriver"
}

variable "firewall_rule_ports" {
  type        = list(string)
  default     = []
  description = "List of ports of firewall rule"
}


