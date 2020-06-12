resource google_compute_global_address global_ip_address {
  for_each = toset(var.dns_names)

  provider = google.ip
  name = "${each.value}-ip"
  depends_on = [var.dependencies]
}

resource google_dns_record_set a_dns {
  for_each = toset(var.dns_names)

  provider = google.dns
  type = "A"
  ttl = "300"

  managed_zone = var.zone_gcp_name
  name = "${each.value}-global.${var.zone_dns_name}"
  rrdatas = [google_compute_global_address.global_ip_address[each.value].address]
  depends_on = [var.dependencies]
}

resource google_dns_record_set cname_dns {
  for_each = toset(var.dns_names)

  provider = google.dns
  type = "CNAME"
  ttl = "300"

  managed_zone = var.zone_gcp_name
  name = "${each.value}.${var.zone_dns_name}"
  rrdatas = [google_dns_record_set.a_dns[each.value].name]
  depends_on = [var.dependencies]
}
