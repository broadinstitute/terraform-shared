#name of external dns_zone name
variable "target_dns_zone_name" {
  type = string
}
#name and destination values ie: record = 192.168.44.22
variable "records" {
  type = map(object({type = string, rrdatas = string}))
}
