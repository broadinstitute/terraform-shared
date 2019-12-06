output "network" {
  value = google_compute_network.vpc-network.name
}

output "network_self_link" {
  value       = google_compute_network.vpc-network.self_link
  description = "The URI of the VPC being created"
}

output "subnets_ips" {
  value       = {
    for subnet in google_compute_subnetwork.subnetwork:
        subnet.region => subnet.ip_cidr_range
   }
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = {
    for subnet in google_compute_subnetwork.subnetwork:
        subnet.region => subnet.self_link
   }
  description = "The self-links of subnets being created"
}

