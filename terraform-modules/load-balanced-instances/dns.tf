provider "google" {
  alias = "dns"
}

data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "${var.dns_zone_name}"
}

# Instance DNS
resource "google_dns_record_set" "instance-dns" {
  provider     = "google.dns"
  count        = "${var.instance_num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-%02d.%s",count.index+1,data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.instances", "data.google_dns_managed_zone.dns-zone"]
}

# Service DNS
resource "google_dns_record_set" "app-dns" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${var.owner}-${var.service}.${data.google_dns_managed_zone.dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  # module.load-balancer.load_balancer_public_ip is an array
  rrdatas      = module.load-balancer.load_balancer_public_ip
  depends_on   = ["module.load-balancer", "data.google_dns_managed_zone.dns-zone"]
}
