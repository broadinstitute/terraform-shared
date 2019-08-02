variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "enable_private_endpoint" {
  type = bool
  default = null
}

variable "enable_private_nodes" {
  type = bool
  default = null
}

variable "private_master_ipv4_cidr_block" {
  type = string
  default = null
}

variable "node_service_account" {
  type    = string
  default = null
}

variable "enable_node_rng" {
  type    = bool
  default = false
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "ip_allocation_policy" {
  type = list(object({
    cluster_ipv4_cidr_block = string,
    cluster_secondary_range_name = string,
    create_subnetwork = bool,
    node_ipv4_cidr_block = string,
    services_ipv4_cidr_block = string,
    services_secondary_range_name = string,
    subnetwork_name = string,
    use_ip_aliases = bool
  }))
  # IMPORTANT: This defaults to `null` instead of `[]`
  # because `[]` overwrites the default argument of the
  # underlying Google resource.
  default = null
}

variable "node_tags" {
  type    = list(string)
  default = []
}

variable "workload_metadata_config_node_metadata" {
  type    = string
  default = "SECURE"
}

# Cluster Variables
variable "cluster_name" {
  type = string
}

variable "cluster_network" {
  type = string
}

variable "cluster_subnetwork" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "master_authorized_network_cidrs" {
  type = list(string)
}

variable "k8s_version" {
  type    = string
  description = "Version of k8s to use in the GKE master and nodes"
}

# Node Pool Variables
variable "node_pool_machine_type" {
  type        = string
  default     = "n1-highmem-8"
}

variable "node_pool_disk_size_gb" {
  type        = number
  default     = 100
  description = "The size of the disk"
}

variable "node_pool_count" {
  type        = number
  default     = 3
  description = "The number of nodes deployed in a node pool"
}

variable "dependencies" {
  type = list(any)
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules"
}
