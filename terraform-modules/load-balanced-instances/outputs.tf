output "service_hostname" {
  value = "${substr(google_dns_record_set.app-dns.name, 0, length(google_dns_record_set.app-dns.name) - 1)}"
}

output "config_bucket_name" {
  value = "${google_storage_bucket.config-bucket.name}"
}
