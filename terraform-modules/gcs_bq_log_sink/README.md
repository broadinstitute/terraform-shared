## Module for GCS  / Bigquery log sink

This module will configure one BigQuery log sink (with configurable TTL)
and one Google Storage log sink (without TTL). In order to create the sink(s),
you _MUST_ set one or both of `enable_gcs` or `enable_bigquery` to `1`.

The _first_ time you use a module, and every time one of the terraform
modules changes, you will need to run `terraform get` from within your
terraform stack.

For other questions, see the [terraform docs](https://www.terraform.io/docs/modules/index.html) on modules
to understand how to use this.

### What This Module Creates

1. A Google Storage Bucket
2. A log sink sending a filter of stackdriver logs to the  bucket
3. A bucket policy granting the log sink from 2 write access to the bucket from 1
4. A BigQuery dataset
5. A log sink sending a filter of stackdriver logs to the data set, with a configurable TTL

### What You Need To Supply To This Module

Below is an annotated sample invocation of this module

```terraform
module "my-app-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=gcs_bq_log_sink-0.0.0"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers {
    google = "google"
  }

  /*
  * REQUIRED VARIABLES
  */

  # The name of the person or team responsible for the lifecycle of this infrastructure
  owner = "rluckom"

  # The name of the application
  application_name = "vault"

  # Name of the google project
  project = "broad-dsp-techops-dev"

  # Filter to use for (both) sinks
  log_filter = "resource.type=\"container\" AND resource.labels.cluster_name=\"${var.application_name}-k8s-cluster\" AND resource.labels.namespace_id=\"${var.owner}\""

  /*
  * OPTIONAL VARIABLES (values are the defaults)
  */
  
  enable_gcs = 0
  
  enable_bigquery = 0
  
  // number of days to keep logs in bq before expiring
  bigquery_retention_days = 31

  // break glass in case of naming conflicts
  nonce = ""
}
```

### Notes

It may take time after applying this module before data starts showing up
in BigQuery and the bucket you create. Logs are written to the bucket in one-hour
files at the top of the hour, so it may be a while  before you see anything.
BigQuery is a bit faster, but you still may need to give it 10+ minutes.
This only picks up logs generated _after_ the sinks are working correctly,
so if your application isn't continuously generating new logs it may be
difficult to verify that this is working as intended. 

To view data in your BigQuery dataset, you first need to find the available tables
in the dataset:

```
SELECT * FROM <dataset-name>.__TABLES__;
```
Once the first table shows up, you can query for a few rows if that helps
you sleep at night:

```
SELECT * FROM <dataset-name>.<table-name> limit 80;
```

#### Deletion

Even if you set the "ok to delete data" flag on the datasets, terraform still
doesn't seem willing to delete them. I do it manually.

#### Privileges

The bucket role that allows the log sink to write to the bucket  you create
may require IAM create permissions.
