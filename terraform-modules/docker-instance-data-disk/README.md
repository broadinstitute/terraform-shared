This module creates a cluster of identical GCE instances with the following options:
  - attached persistent disk that is intended to be used for docker storage
  - at least one additional persistent disk to be used as data volume(s)

The following are the module defaults:

instance_name: docker-data-node
instance_region: us-central1
instance_zone: us-central1-a
instance_num_hosts: 1
instance_root_disk_size: 50
instance_size: n1-standard-1
instance_image: centos-7
instance_docker_disk_size: 50
instance_docker_disk_type: pd-ssd
instance_docker_disk_name: docker
instance_data_disk_size: 50
instance_data_disk_type: pd-sd
instance_data_disk_name: data
instance_scopes:
    "userinfo-email",
    "compute-ro",
    "storage-ro",
    "https://www.googleapis.com/auth/monitoring.write",
    "logging-write" 

The following module variables have an empty string/list/map as default:

instance_subnetwork_name: 
instance_tags
instance_labels
instance_service_account

NOTE: instance_subnetwork_name is required and applying the plan will fail even though creating the plan will succeed.
