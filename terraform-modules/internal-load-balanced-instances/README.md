This module creates a cluster of identical GCE instances for deploying a containerized service,
puts them behind a HTTP load balancer, and assigns DNS records for each instance and the
load balancer. It also creates a GCS bucket for storing configs for the service and gives access
to the GCS bucket to the specified service account.

This module requires that the DNS zone resource (where the individual DNS 
entries will be created) has been created outside of this module. If it
does not exist this module will fail.

### Required Providers

`google.instances`: A google provider to deploy the instances.

`google.dns`: a Google provider to deploy the DNS.

### Required Variables

`instance_project`: the google project into which to deploy the instances

`dns_zone_name`: The name of the DNS zone according to Google, e.g. `dsde-perf-broad`

`owner`: the owner of the deployment

`service`: the name of the service

`dns_project`: the name of the project in which the DNS will be deployed

`google_network_name`: the name of the network in which to deploy the instances

`load_balancer_subnetwork_name`: the name of the subnetwork in which to deploy the load balancer. If not specified, defaults to the name of the network, which works for networks created with auto subnets but will likely not work for networks with subnetworks provisioned in other ways.

`config_reader_service_account`: The service account that should have access to the config bucket

`instance_tags`: a list of tags to give the instances

`instance_num_hosts`: the number of instance hosts

`instance_size`: the [size](https://cloud.google.com/compute/docs/machine-types) of the instances.

### Non-Required variables

`storage_bucket_roles`: a list of roles to give the reader service account on the bucket. Defaults to

```
  [
    "roles/storage.legacyBucketReader",
    "roles/storage.objectViewer"
  ]
```

`dns_ttl`: defaults to 300

`ansible_branch`: the branch of [dsp-ansible-configs](https://github.com/broadinstitute/dsp-ansible-configs) the instances should use.
