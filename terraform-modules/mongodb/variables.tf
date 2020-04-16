# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable dependencies {
  type = any
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

# General
variable "project" {}
variable "owner" {
  description = "The owner from the application json"
}
variable "service" {
  description = "The name of the service within the profile"
}

# DNS

variable "dns_zone_name" {
  description = "The full DNS zone without a trailing . as specified in the application json"
  default = "none"
}
variable "dns_ttl" {
   default = "300"
}

# SA

variable "mongodb_service_account" {
  description = "Service Account email"
}


# Instance
variable "instance_region" {
  default = "us-central1"
  description = "The region where instances will be created"
}

variable "instance_zone" {
  default = "us-central1-a"
  description = "The zone where instances will be created"
}

variable "instance_group_name" {
  default = null
  description = "Name of instance group. Defaults to [instance name]-instance-group-unmanaged"
}

variable "instance_root_disk_size" {
  default = "50"
  description = "default size of instance"
}

variable "instance_size" {
  default = "n1-standard-1"
  description = "default size of instance"
}

variable "instance_image" {
  default = "centos-7"
  description = "Image used to build instance"
}

variable "instance_count_offset" {
  default = 0
  type    = number
  description = "Offset at which to start naming suffix. If set to 1, first foo instance created will be foo-02"
}

variable "instance_docker_disk_size" {
  default = "50"
  description = "default size of docker volume"
}

variable "instance_docker_disk_type" {
  default = "pd-ssd"
  description = "default disk type for docker volume"
}

variable "instance_docker_disk_name" {
  default = "docker"
  description = "default disk type for docker volume"
}

variable "instance_network_name" {
  default = ""
  description = "The default network name to create instance"
}

variable "instance_subnetwork_name" {
  default = ""
  description = "The default subnetwork name to create instance"
}

variable "instance_scopes" {
  type    = list(string)
  description = "The default scopes for instance"
  default = [
    "userinfo-email", 
    "compute-ro", 
    "storage-ro", 
    "https://www.googleapis.com/auth/monitoring.write", 
    "logging-write" ]
}

variable "instance_tags" {
  type    = list(string)
  description = "The default tags for instance"
  default = [ ]
}

variable "instance_labels" {
  type    = map
  description = "The default labels for instance"
  default = { }
}

variable "instance_stop_for_update" {
  default = true
  description = "The default is to allow stopping instance for updating"
}

variable "instance_metadata_script" {
  default = "centos-ansible.sh"
  description = "default metadata script"
}

# Data disk variables

variable "instance_data_disk_size" {
  default = "200"
  description = "default size of docker volume"
}

variable "instance_data_disk_type" {
  default = "pd-standard"
  description = "default disk type for docker volume"
}

variable "instance_data_disk_name" {
  default = "data"
  description = "default disk type for docker volume"
}

#
# Service Config Bucket
#
variable "storage_bucket_roles" {
  type = list(string)

  default = [
    "roles/storage.legacyBucketReader",
    "roles/storage.objectViewer"
  ]
}

# Mongo variables

variable "mongodb_image_tag" {
  default = "3.6.14"
}

variable "mongodb_roles" {
  default = [
    "primary",
    "secondary",
    "arbiter"
  ]
  description = "host roles that will be present in this cluster"
}

variable "mongodb_host_port" {
  default = "27017"
}

variable "mongodb_container_port" {
  default = "27017"
}

variable "mongodb_data_path" {
  default = "/local/mongodb_data"
}

variable "mongodb_app_username" {}

variable "mongodb_app_password" {}

variable "mongodb_root_password" {}

variable "mongodb_replica_set_key" {
  default = "default"
}

variable "mongodb_extra_flags" {
  type = string
  description = "Extra flags passed to the mongo container. https://github.com/bitnami/bitnami-docker-mongodb#passing-extra-command-line-flags-to-mongod-startup"
  default = null
}

variable "mongodb_database" {}

variable "roles" {
  default = ["username1", "username2"]
}
