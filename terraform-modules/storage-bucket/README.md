# Module for creating google buckets

- This module creates buckets, ACLs and lifecycle from a map variable

### Prerequisite
- Terraform 0.12.6+

### Example Use
```
  provider = google.broad-gotc-dev
  bucket_name = "aou-input"
  versioning = true
  
  # Defining ACLs for each role
  bindings = {
    storage_admins = {
      role = "roles/storage.admin"
      members = [
        "user:ftraquet@broadinstitute.org",
      ]
    },
    admins = {
      role = "roles/storage.objectAdmin"
      members = [
        "group:hornet@broadinstitute.org",
      ]
    },
    viewers = {
      role = "roles/storage.objectViewer"
      members = [
        "group:lantern@broadinstitute.org",
      ]
    }
  }

```
### Variables to set
```
# name of bucket
bucket_name =
# name of provider
provider =
# ACL list
bindings =

# Default Class Storage = "MULTI_REGIONAL"
# Default location = "US"
# Default versioning = "false"
```
