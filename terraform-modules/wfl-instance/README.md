This is sort of a meta module that creates all the specific elements needed to run Workflow Launcher (WFL).

The elements that this module creates are:
 * Global IP address (to be used by the WFL helm chart)
 * DNS name for the wfl instance
 * PostgreSQL database
 * A pair of GCS buckets to be used by WFL for the inputs and outputs for workflows being managed by WFL
 * An isolated namespace in the given cluster

NOTES: 
1. The module requires specifying instance_id which is an unique identifier that will be added to the name of all created resources.  The module sets it to null and uses variable validation to ensure that a non-null value is passed in.  Module will fail/error if instance_id is not passed in.

2. This module does not create a GKE cluster but it does manage its own namespace. As such, it requires cluster's name and location and a reference to the module responsible for managing the cluster (to properly declare the dependency).


```
module "wfl" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/wfl-instance?ref=wfl-instance-0.0.1"

  instance_id        = "my-wfl"         
  project            = "google-project"         
  owner              = "my-name"

  depends_on_cluster = module.k8s-master.name
  cluster_name       = "the-cluster-name"
  cluster_location   = "us-central1-a"
}                                                                        
```

## Required Providers

Module accepts two providers. One provider is used for all the infrastructure that is created and the second provider is used for creating the DNS record.  The idea here is that a lot of times the DNS zone is centrally managed and as such is in a different google project.  You can pass in the providers by supplying the following code block when you call module

```
  providers = {                                                          
    google              = google.my-provider
    google.dns_provider = google.dnszone
  }                                                                      
```

The module will also independently configure a `kubernetes` provider to interact with the given cluster.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| instance_id | Unique id that will be inserted in all resource names. This will also be used for labels on resources that support labeling. | string | null | yes |
| project | Google project that will be used to create the postgres database in.  This is a legacy requirement until the CloudSQL Postgres module is updated to support project inheritence.  Hence not require provideing a google project | string | NULL | yes |
| owner | Username creating the instance.  Used to create an owner label for resources that support labelling | string | NULL | no |
| depends_on_cluster | A reference to some output from the module responsible for managing the GKE cluster. Ensures that module completes before configuring the namespace. | string | NULL | yes |
| cluster_name | The name of the GKE cluster to configure a namespace in. | string | NULL | yes |
| cluster_location | The location of the GKE cluster to configure a namespace in. | string | NULL | yes |


## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| wfl-public-ip | External IP address for WFL | string | 
| wfl-input-bucket | Name of input bucket for WFL | string | 
| wfl-output-bucket | Name of output bucket for WFL | string | 
| wfl-db-connection | PostgreSQL database connection string | string | 
| wfl-dns-name | FQDN of wfl external IP | string | 
| wfl-kubernetes-namespace | Name of the namespace in the cluster | string |

## Labeling

In pursuit of allowing Terraform resources to be better identified by deployment scripts, resources created by this module adopt the following labeling scheme based on the module inputs:

| Key | Value |
|-----|:-----:|
| app_name | wfl |
| instance_id | {instance_id} |

The above scheme means that the following argument can [filter](https://cloud.google.com/sdk/gcloud/reference/topic/filters) `gcloud` list invocations to resources associated with this instance:

```bash
--filter="labels.app_name=wfl AND labels.instance_id={instance_id}"
```