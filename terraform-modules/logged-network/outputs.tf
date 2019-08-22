output "name" {
  value = google_compute_network.app-services.name
}

output "subnets" {
  value = var.subnet_cidrs
}
