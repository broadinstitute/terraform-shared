
output "services" {
  value = google_project_service.required-services
}

output "service_map" {
  value = { for indx,val in google_project_service.required-services: val[service] => val }
}
