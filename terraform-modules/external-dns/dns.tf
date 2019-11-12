terraform {
  required_version = ">= 0.12.6"
}

data "google_dns_managed_zone" "dns_zone" {
    provider     = "google.targetdns"
    project      = var.target_project
    name         = var.target_dns_zone_name
}

resource "google_dns_record_set" "set_dns_record" {
  iterator = setting
  for_each = [for s in var.records: {
    name = s.name
    type = s.type
    rrdatas = s.rrdatas
  }]

  content {
    name = "${setting.value.name}.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type = setting.value.type
    rrdatas = setting.value.rrdatas
    provider     = "google.targetdns"
    ttl          = "300"
    managed_zone = data.google_dns_managed_zone.dns_zone.name
  }
}
