## Module for enabling api servics on GCP

## Default Behavior
This will enable 41 apis by default if you would like specify apis you can do so by defining a variable like below

### sample deploy variable
```
module "enable-services" {

  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=ms-apiservices"

  providers {
    google = "google-beta"
  }
  project = "broad-myproject-dev"
  services = [
    "appengineflex.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddebugger.googleapis.com",
    "cloudkms.googleapis.com"
    ]
  }
 ```
