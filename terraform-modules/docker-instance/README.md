This module creates a cluster of identical GCE instances for deploying a containerized service

The following are the module defaults:

instance_name: docker-node
instance_region: us-central1
instance_zone: us-central1-a
instance_num_hosts: 1
instance_root_disk_size: 50
instance_size: n1-standard-1
instance_image: centos-7
instance_docker_disk_size: 50
instance_docker_disk_type: pd-ssd
instance_docker_disk_name: docker
instance_scopes:
    "userinfo-email",
    "compute-ro",
    "storage-ro",
    "https://www.googleapis.com/auth/monitoring.write",
    "logging-write" 
instance_stop_for_update: true

The following module variables have an empty string/list/map as default:

instance_subnetwork_name:
instance_tags
instance_labels
instance_service_account

NOTE: instance_subnetwork_name is required and applying the plan will fail even though creating the plan will succeed.
