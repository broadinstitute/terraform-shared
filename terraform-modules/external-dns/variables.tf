# google project
variable "target_project" {}
#region
variable "region" {}
#credentials
variable "target_credentials" {}
#name of external dns_zone name
variable "target_dns_zone_name" {}
#record type
variable "record_type" {}
#name and destination values ie: record = 192.168.44.22
variable "records" {
  type = map
}
