# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable dependencies {
  type = any
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

# module wide vars
# google project
variable "project" {}

# enable/disable var
variable "enable_flag" {
   default = "1"
}

variable "instance_name" {
  default = "docker-data-node"
  description = "root instance names"
}

variable "instance_region" {
  default = "us-central1"
  description = "The region where instances will be created"
}

variable "instance_zone" {
  default = "us-central1-a"
  description = "The zone where instances will be created"
}

variable "instance_service_account" {
  default = ""
  description = "The service account under which the instances will be created"
}

variable "instance_num_hosts" {
  default = "1"
  description = "default number of instances this module will create"
}

variable "instance_count_offset" {
  default = 0
  type    = number
  description = "Offset at which to start naming suffix. If set to 1, first foo instance created will be foo-02"
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

variable "instance_group_name" {
  default = null
  description = "Name of instance group. Defaults to [instance name]-instance-group-unmanaged"
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
  default = "50"
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

# control adding resource policy to GCE instances
# sets instance schedules to start/stop VMs automatically via cron schedule
# see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy#example-usage---resource-policy-instance-schedule-policy
variable "enable_resource_policy" {
  default = false
}

variable "instance_schedule_vm_start" {
  description = "Cron schedule for starting GCE instances using policy; default 9AM daily"
  default = "0 9 * * *"
}

variable "instance_schedule_vm_stop" {
  description = "Cron schedule for stopping GCE instances using policy; default 5PM daily"
  default = "0 17 * * *"
}

variable "instance_schedule_time_zone" {
  description = "Timezone for GCE instance schedule policies"
  default = "US/Central"
}
