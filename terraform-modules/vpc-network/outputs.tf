output "name" {
  value = google_compute_network.vpc-network.name
}

output "subnets" {
  value = var.subnets
}
