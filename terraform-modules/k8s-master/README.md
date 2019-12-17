## Module for CIS-Compliant K8s Master

This module hopes to get you running a CIS-compliant GKE master as
quickly as possible.

### What This Module Creates

A GKE cluster with no node pools. To run workloads on the cluster,
you'll need to use the [node pool](../k8s-node-pool) module to
provision compute. You can also use the [full cluster](../k8s) module
to provision a master with a single node pool, if you don't need as
fine-grained control over worker machines.

### CIS Benchmarks

Kubernetes on Google is a subject of [CIS Benchmarks](https://learn.cisecurity.org/benchmarks)
recommending security best practices. The following is an unauthoritative
summary of the CIS benchmarks for Kubernetes with notes on whether they fall
into the scope of terraform and if so, how they are addressed here. Within
the code, values relevant to CIS compliance are noted in comments.

1. **Stackdriver Logging Enabled** - Enabled in the cluster resource definition "logging_service"
1. **Stackdriver Monitoring Enabled** - Enabled in the cluster resource definition "monitoring_service"
1. **Legacy Auth Disabled** - Disabled in the cluster resource definition "enable_legacy_abac"
1. **Dashboard Disabled** - Disabled in the cluster resource definition "disabled"
1. **Basic Auth Disabled** - Set a client certificate in the "master_auth" block according to the [tf docs](https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_auth). By using the "master auth" block and not setting a username and password, basic auth is disabled.
1. **Client Certificate Enabled** - Set a client certificate in the "master_auth" block according to the [tf docs](https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_auth).
1. **Network Policy Enabled** - Enabled under "network_policy" in the k8s cluster resource.
1. **Enable Alias IP Ranges** - Set in the "ip_allocation_policy" in the cluster resource
1. **PodSecurityPolicyController is enabled** - Enabled in the `pod_security_policy_config` block in the cluster resource.
1. **Created with Private Cluster Enabled** - NOT COVERED - we need access to the internet for Vault.
1. **Enable Private Access To Google Services** - NOT COVERED -- subnet setting.
