# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable "dependencies" {
  type = any
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules"
}

# Cluster Variables
variable "cluster_name" {
  type = string
}

variable "location" {
  type = string
  default = "us-central1"
  description = "Zone or region to host the k8s master and node pool"
}

variable "k8s_version" {
  type    = string
  description = "Version of k8s to use in the GKE master and nodes"
}

variable "cluster_network" {
  type = string
}

variable "cluster_subnetwork" {
  type = string
}

variable "master_authorized_network_cidrs" {
  type = list(string)
}

variable "private_master_ipv4_cidr_block" {
  type = string
}

variable "enable_private_nodes" {
  type = bool
  default = true
}

variable "enable_private_endpoint" {
  type = bool
  default = false
}

# Node Pool Variables
variable "node_pool_count" {
  type        = number
  default     = 3
  description = "The number of nodes deployed in a node pool"
}

variable "node_pool_machine_type" {
  type        = string
  default     = "n1-highmem-8"
}

variable "node_pool_disk_size_gb" {
  type        = number
  default     = 100
  description = "The size of the disk"
}

variable "node_service_account" {
  type    = string
  default = null
}

variable "workload_metadata_config_node_metadata" {
  type    = string
  default = "SECURE"
}

variable "node_metadata" {
  type = map(string)
  default = {
    google-compute-enable-virtio-rng = false,
    disable-legacy-endpoints = true
  }
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "node_tags" {
  type    = list(string)
  default = []
}
