## Module for CIS-Compliant K8s Clusters

This module hopes to get you running a CIS-compliant k8s cluster as
quickly as possible. 

The _first_ time you use a repo, and every time one of the terraform
modules (the files in the `/modules` directory) changes, you will need
to run `./terraform.sh get` from within the repo.

For other questions, see the [terraform docs](https://www.terraform.io/docs/modules/index.html) on modules
to understand how to use this.

### What This Module Creates

1. A k8s cluster
2. A k8s node pool

### What You Need To Supply To This Module

Below is an annotated working invocation of this module

```terraform
module "my-k8s-cluster" {
  # Assuming the root of this repo
  source = "./modules/k8s"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers {
    google = "google-beta"
  }

  /*
  * REQUIRED VARIABLES
  */

  # Name for your cluster (use dashes not underscores)
  cluster_name = "my-k8s-cluster"

  # Network where the cluster will live (must be full resource path)
  cluster_network = "projects/broad-dsde-dev/global/networks/samnet"

  # Subnet where the cluster will live (must be full resource path)
  cluster_subnetwork = "projects/broad-dsde-dev/regions/us-central1-a/subnetworks/samnet/sam-subnet"

  # CIDR to use for the hosted master netwok. must be a /28 that does NOT overlap with the network k8s is on
  master_ipv4_cidr_block = "10.128.1.0/28"
  
  # CIDRs of networks allowed to talk to the k8s master
  master_authorized_network_cidrs = "${var.broad_range_cidrs}"

  /*
  * OPTIONAL VARIABLES (values are the defaults)
  */
  
  # k8s Node Version (CIS-relevant)
  node_version = "1.11.4-gke.8"

  # k8s Master Version (CIS Relevant)
  master_version = "1.11.6-gke.6"

  # Disk size for the nodes in the cluster
  node_pool_disk_size_gb = "100"

  # Zone for all resources
  zone = "us-central1-a"

  # number of nodes in your node pool
  node_pool_count = "3"

  # Machine type of the nodes
  node_pool_machine_type = "n1-highmem-8"
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
