# Module for creating google buckets

- This module creates buckets, ACLs and lifecycle from a map variable

### Prerequisite
- Terraform 0.12.+


### Example Use
```
  provider = google.broad-gotc-dev
  bucket_name = "aou-input"
  versioning = false
  # versioning and retention policy are mutually exclusive features
  retention_policy = {
    # lock the objects in the bucket until a certain period in sec - 2,678,400 = a month
    is_locked        = true
    retention_period = 2678400
  }

  lifecycle_rules = [
    {
      # Delete objects on the bucket after 60 days from creation
      action = {
        type = "Delete"
      },
      condition = {
        age = 60
        with_state = "ANY"
      }
    }]
  
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

  labels = {
    key = "value"
  }

```
## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket_name | The name of the bucket to create | string | null | yes |
| provider | The provider used to create resources | string | google | no |
| bindings | Map of binding names containing roles and members | map | null | yes |
| versioning | Enable versioning on the bucket | boolean | false | no |
| storage_class | Bucket storage class - STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE -  | string | "MULTI_REGIONAL" | no |
| location | Bucket location | string | "US" | no |
| lifecycle_rules | List of lifecycle rules to configure | object | null | no | 
| retention_policy | Configuration of the bucket's data retention policy for how long obje cts in the bucket should be retained. | object | null | no | 
| labels | A set of key/value label pairs to assign to the bucket | map | null | no |

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| bucket_name | bucket created | google resource | 
```
