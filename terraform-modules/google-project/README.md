## Module for Creating a Google Project for use with Google Cloud Platform

## Default Behavior
This module will create a folder-based Google Project by default. The default behavior is to NOT destroy the project on resource destory.  This can be overriden by setting the destroy variable to true.

If you would like to disable all the resources this module creates without needing to comment it out in your terraform config, you can set the enable\_flag to 0

## Google Provider
In order to support applying multiple instances of this module to different Google projects all in the same terraform configuration, you MUST specify the google provider when you instantuate the module.  The google provider used by the module is "named" google.target - in order to ensure no conflict or assumption on the provider you desire to use.

## Service List Ordering
Due to how the module is implemented - iterating through the list and creating a "instance" of the resource for each service - changing the order of the list will cause a lot of destroy/creation tasks - which may not be desireable.  So it is best to add at the end of your service list after the initial apply.

### Sample Deploy Variable
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
