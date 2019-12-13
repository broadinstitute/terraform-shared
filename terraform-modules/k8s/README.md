## Module for CIS-Compliant K8s Clusters

This module hopes to get you running a CIS-compliant k8s cluster as
quickly as possible.

The _first_ time you use a module, and every time one of the terraform
modules changes, you will need to run `terraform get` from within your
terraform stack.

For other questions, see the [terraform docs](https://www.terraform.io/docs/modules/index.html) on modules
to understand how to use this.

### What This Module Creates

1. A k8s cluster
2. A k8s node pool

### What You Need To Supply To This Module

Below is an annotated sample invocation of this module

```terraform
variable "cluster_name" {
  type = string
  default = "terra-k8s-{{env "OWNER"}}"
}

variable "cluster_network" {
  type = string
  default = "{{env "CLUSTER_NETWORK"}}"
}

variable "cluster_subnetwork" {
  type = string
  default = "{{env "CLUSTER_SUBNETWORK"}}"
}

variable "broad_range_cidrs" {
  type    = "list"
  default = [ "69.173.64.0/19",
    "69.173.96.0/20",
    "69.173.112.0/21",
    "69.173.120.0/22",
    "69.173.124.0/23",
    "69.173.126.0/24",
    "69.173.127.0/25",
    "69.173.127.128/26",
    "69.173.127.192/27",
    "69.173.127.224/30",
    "69.173.127.228/32",
    "69.173.127.230/31",
    "69.173.127.232/29",
    "69.173.127.240/28" ]
}

variable "k8s_version" {
 default = "1.14.6-gke.13"
}

provider "google-beta" {
  credentials = "${file("default.sa.json")}"
  project = "{{env "GOOGLE_PROJECT"}}"
  region = "us-central1"
}

module "my-k8s-cluster" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s?ref=k8s-0.2.0-tf-0.12"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers = {
    google = "google-beta"
  }

  /*
  * REQUIRED VARIABLES
  */

  k8s_version = var.k8s_version

  # Name for your cluster (use dashes not underscores)
  cluster_name = var.terra_cluster_name

  # Network where the cluster will live (must be full resource path)
  cluster_network = "projects/<project-name>/global/networks/<network-name>"

  # Subnet where the cluster will live (must be full resource path)
  cluster_subnetwork = "projects/<project-name>/regions/us-central1/subnetworks/<subnet-name>"

  # Network where the cluster will live (must be full resource path)
  cluster_network = var.cluster_network

  # Subnet where the cluster will live (must be full resource path)
  cluster_subnetwork = var.cluster_subnetwork

  # CIDR to use for the hosted master netwok. must be a /28 that does NOT overlap with the network k8s is on
  private_master_ipv4_cidr_block = "10.128.1.0/28"

  # CIDRs of networks allowed to talk to the k8s master
  master_authorized_network_cidrs = var.broad_range_cidrs

  /*
  * OPTIONAL VARIABLES (values are the defaults)
  */

  # Disk size for the nodes in the cluster
  node_pool_disk_size_gb = "100"

  # number of nodes in your node pool
  node_pool_count = "3"

  # Machine type of the nodes
  node_pool_machine_type = "n1-highmem-8"

  # service account credentials to give the nodes, empty string means default
  node_service_account = ""

  # labels to give the nodes
  node_labels = {}

  # tags to give the nodes
  node_tags = []

  # Restrict visibility to node metadata
  workload_metadata_config_node_metadata = "SECURE"
}
```

### CIS Benchmarks

Kubernetes on Google is a subject of [CIS Benchmarks](https://learn.cisecurity.org/benchmarks)
recommending security best practices. See the READMEs for the underlying
[k8s-master](../k8s-master/README.md) and [k8s-node-pool](../k8s-node-pool/README.md)
modules for summaries of which CIS benchmarks are addressed by each.
