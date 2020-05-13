# Module for creating google buckets

- This module creates buckets, ACLs and lifecycle from a map variable

### Prerequisite
- Terraform 0.12.6+

### Example Use
```
  project_id  = aou
  buckets_name = ["aou-input", "aou-ouput"]
  prefix = aou
  location = "US"
  
  # default versioning is false - need to define for each bucket
  versioning = {
    aou-input = true
    aou-ouput = true
  }

  set_admin_roles = true
  bucket_admins = [
    "serviceAccount:service_account.admin.email"
  ]

  set_viewers_roles = true
  bucket_viewers = [
    "serviceAccount:service_account.viewer.email",
    "group:developers@broadinstitute.org"
  ]
  
  set_legacy_roles = true
  bucket_legacy = [
    "serviceAccount:service_account.legacy.email"
  ]

```
### Variables to set
```
#name of buckets
buckets_name =
#name of prefix
prefix =
#name of project
project_id  =

#Default Class Storage = "MULTI_REGIONAL"
#Default location = "US"
```
