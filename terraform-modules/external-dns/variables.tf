# google project
variable "target_project" {
  type = string
}
#region
variable "region" {
  type = string
}
#credentials
variable "target_credentials" {
  type = string
}
#name of external dns_zone name
variable "target_dns_zone_name" {
  type = string
}
#name and destination values ie: record = 192.168.44.22
variable "records" {
  type = map(object({type = string, rrdatas = string}))
}