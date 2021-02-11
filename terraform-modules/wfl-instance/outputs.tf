

output wfl-public-ip {
  value = module.ip-dns.public_ip.address
}

output wfl-input-bucket {
  value = module.input-bucket.bucket.name
}

output wfl-output-bucket {
  value = module.output-bucket.bucket.name
}

output wfl-db-connection {
  value = module.postgres.connection_name
}

output wfl-dns-name {
  value = "${var.instance_id}-wfl.${data.google_dns_managed_zone.dns_zone.dns_name}"
}

output wfl-instance {
  value = map(
      "public_ip", module.ip-dns.public_ip.address,
      "input_bucket_name", module.input-bucket.bucket.name,
      "output_bucket_name", module.output-bucket.bucket.name
    )
}

output wfl-kubernetes-namespace {
  value = local.namespace
}
