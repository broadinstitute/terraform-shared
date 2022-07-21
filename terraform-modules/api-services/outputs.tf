
output "services" {
  value = { for indx,val in google_project_service.required-services: val.service => val }
}
