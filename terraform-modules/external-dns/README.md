# Module for creating DNS

- This module creates dynamic A record, CNAME and more from a map variable

### Prerequisite
- Terraform 0.12.6+

### Example Use
```
variable "records" {
  default = {
    record1 = {
      type = "A"
      rrdatas = "192.163.155.12"
    },
    recordcname2 = {
      type = "CNAME"
      rrdatas = "record1.datarepo-dev.broadinstitute.org."
    },
    record3 = {
      type = "A"
      rrdatas = "192.55.77.11"
    }
  }
}

module "dns-test" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=ms-dns-creator-v2"

  target_project = var.env_project
  target_dns_zone_name = "datarepo-dev"
  records = var.records
}
```
### Variables to set
```
# google project
variable "target_project" {}
#name of external dns_zone name
variable "target_dns_zone_name" {}
#name and destination values ie: record = 192.168.44.22
variable "records" {}
```
