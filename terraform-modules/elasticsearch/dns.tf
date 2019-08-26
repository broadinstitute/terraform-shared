provider "google" {
  alias = "dns"
}

data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "${var.dns_zone_name}"
}

resource "google_dns_record_set" "dns-a" {
  provider     = "google.dns"
  count        = "${var.num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-%02d.%s",count.index+1,data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_public_ips, count.index)}" ]
  depends_on   = [module.instances, data.google_dns_managed_zone.dns-zone]
}

resource "google_dns_record_set" "dns-a-priv" {
  provider     = "google.dns"
  count        = "${var.num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-priv-%02d.%s",count.index+1,data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_private_ips, count.index)}" ]
  depends_on   = [module.instances, data.google_dns_managed_zone.dns-zone]
}

data "null_data_source" "hostnames_with_no_trailing_dot" {
  count = var.num_hosts
  inputs = {
    hostname = "${substr(element(google_dns_record_set.dns-a.*.name, count.index), 0, length(element(google_dns_record_set.dns-a.*.name, count.index)) - 1)}"
    hostname_priv = "${substr(element(google_dns_record_set.dns-a-priv.*.name, count.index), 0, length(element(google_dns_record_set.dns-a-priv.*.name, count.index)) - 1)}"
  }
  depends_on = [google_dns_record_set.dns-a, google_dns_record_set.dns-a-priv, module.instances ]
}
