## Module for enabling api servics on GCP

## Default Behavior
This will enable 41 apis by default if you would like specify apis you can do so by defining a variable like below

## Google Provider
In order to support applying multiple instances of this module to different Google projects all in the same terraform configuration, you MUST specify the google provider when you instantuate the module.  The google provider used by the module is "named" google.target - in order to ensure no conflict or assumption on the provider you desire to use.

### sample deploy variable
```
provider "google" {
   alias   = "my-project"
   project = "broad-myproject-dev"
   region  = "us-central1-a"
}

module "enable-services" {

  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=ms-apiservices"

  providers {
    google.target = "google.my-project"
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
