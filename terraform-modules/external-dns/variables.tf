variable dns_names {
  type = list(string)
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
}

variable dependencies {
  type = any
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

variable zone_gcp_name {
  type = string
  description = "GCP name for the managed DNS zone to generate records within."
}

variable zone_dns_name {
  type = string
  description = "DNS name of the zone to generate records within."
}
