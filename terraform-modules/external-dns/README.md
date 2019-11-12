# Module for creating DNS

- This module creates dynamic A record, CNAME and more from a map variable

### Prerequisite
- Terraform 0.12.6+

### Example Use
```
variable "records" {
  default = {
      record1 = "192.163.155.12"
      record2 = "192.55.22.22"
  }
}

variable "record_type" {
  default = "A"
}

module "dns-test" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=ms-external-dns"

  target_project = var.env_project
  region = var.region
  target_credentials = file("${var.env}_svc.json")
  target_dns_zone_name = "datarepo-dev"
  records = var.records
  record_type = var.record_type
}
```
### Variables to set
```
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
```
