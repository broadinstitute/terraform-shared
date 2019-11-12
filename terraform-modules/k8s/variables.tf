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
  default = "us-central1-a"
  description = "Zone or region to host k8s. NOTE: passing a region here will give you a regional cluster with 3x the number of nodes."
}

variable "k8s_version" {
  type    = string
  description = "Version of k8s to use in the GKE master and nodes"
}

variable "use_new_stackdriver_apis" {
  type = bool
  default = true
  description = "If true, GKE's new APIs for logging / monitoring will be enabled. Otherwise legacy APIs will be used."
}

variable "enable_workload_identity" {
  type = bool
  default = false
  description = "If true, enables k8s<->GCP SA linking in the cluster. See: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity"
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
