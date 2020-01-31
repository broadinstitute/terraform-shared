## Module for CIS-Compliant K8s Clusters

### This Module is Deprecated
We recommend using separate modules for GKE [master](../k8s-cluster) and [node pool](../k8s-node-pool).
This module is left untouched so existing users can apply bug-fixes without being forced to rebuild
their clusters.

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
recommending security best practices. The following is an unauthoritative
summary of the CIS benchmarks for Kubernetes with notes on whether they fall
into the scope of terraform and if so, how they  are addressed here. Within
the code, values relevant to CIS compliance are noted in comments.

1. **Stackdriver Logging Enabled** - Enabled in the cluster resource definition "logging_service"
1. **Stackdriver Monitoring Enabled** - Enabled in the cluster resource definition "monitoring_service"
1. **Legacy Auth Disabled** - Disabled in the cluster resource definition "enable_legacy_abac"
1. **Dashboard Disabled** - Disabled in the cluster resource definition "disabled"
1. **Automatic Node Repair Enabled** - enabled in the "management" section of the node pool resource
1. **Automatic Node Upgrades Enabled** - enabled in the "management" section of the node pool resource
1. **Use Container Optimized OS** - Set in the node pool "Image_type"
1. **Basic Auth Disabled** - Set a client certificate in the "master_auth" block according to the [tf docs](https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_auth). By using the "master auth" block and not setting a username and password, basic auth is disabled.
1. **Network Policy Enabled** - Enabled under "network_policy" in the k8s cluster resource.
1. **Client Certificate Enabled** - Set a client certificate in the "master_auth" block according to the [tf docs](https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_auth).
1. **Enable Alias IP Ranges** - Set in the "ip_allocation_policy" in the cluster resource
1. **PodSecurityPolicyController is enabled** - Enabled in the `pod_security_policy_config` block in the cluster resource.
1. **Created with Private Cluster Enabled** - NOT COVERED - we need access to the internet for Vault.
1. **Enable Private Access To Google Services** - NOT COVERED -- subnet setting.
1. **Don't Use Default Service Account** - NOT COVERED -- I think we can limit oauth scopes instead
1. **Limit OAuth Scopes Used By Nodes** - The `oauth_scopes` array in the node pool resource specifies oauth scopes.
