variable "zone" {
  default = "us-central1-a"
}

variable "private_cluster_config" {
  type = "list"
  default = []
}

variable "node_service_account" {
  default = ""
}

variable "enable_node_rng" {
  default =  false
}

variable "node_labels" {
  type = "map"
  default = {}
}

variable "ip_allocation_policy" {
  type = "list"
  default = [
    {
      cluster_ipv4_cidr_block = ""
      services_ipv4_cidr_block = ""
    }
  ]
}

variable "node_tags" {
  type = "list"
  default = []
}

variable "workload_metadata_config_node_metadata" {
  default = "SECURE"
}

# Cluster Variables
variable "cluster_name" {}

variable "cluster_network" {}

variable "cluster_subnetwork" {}

variable "master_ipv4_cidr_block" {}

variable "master_authorized_network_cidrs" {
  type = "list"
}

variable "master_version" {
  default = "1.12.5-gke.10"
}

# Node Pool Variables
variable "node_version" {
  default = "1.12.5-gke.10"
  description = "The version of the kubernetes software deployed on the kubernetes nodes"
}

variable "node_pool_machine_type" {
  default = "n1-highmem-8"
  description = ""
}

variable "node_pool_disk_size_gb" {
  default = "100"
  description = "The size of the disk"
}

variable "node_pool_count" {
  default = "3"
  description = "The number of nodes deployed in a node pool"
}
#depends_on work around
variable "depends_on" { default = [], type = "list" }
