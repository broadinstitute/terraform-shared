## Module for CIS-Compliant K8s Node Pool

This module hopes to get you running a CIS-compliant GKE node pool as
quickly as possible.

### What This Module Creates

A node pool attached to an existing GKE master. To provision the master,
you'll need to use the [master](../k8s-master) module. You can also use the
[full cluster](../k8s) module to provision a master with a single node pool, if you
don't need as fine-grained control over worker machines.

### CIS Benchmarks

Kubernetes on Google is a subject of [CIS Benchmarks](https://learn.cisecurity.org/benchmarks)
recommending security best practices. The following is an unauthoritative
summary of the CIS benchmarks for Kubernetes with notes on whether they fall
into the scope of terraform and if so, how they are addressed here. Within
the code, values relevant to CIS compliance are noted in comments.

1. **Automatic Node Repair Enabled** - enabled in the "management" section of the node pool resource
1. **Automatic Node Upgrades Enabled** - enabled in the "management" section of the node pool resource
1. **Use Container Optimized OS** - Set in the node pool "Image_type"
1. **Don't Use Default Service Account** - NOT COVERED -- I think we can limit oauth scopes instead
1. **Limit OAuth Scopes Used By Nodes** - The `oauth_scopes` array in the node pool resource specifies oauth scopes.
