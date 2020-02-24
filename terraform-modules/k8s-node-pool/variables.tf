# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable dependencies {
  type = any
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules"
}

variable name {
  type = string
  description = "Name to assign to the node pool."
}

variable master_name {
  type = string
  description = "Name of the GKE master / cluster where the node pool should be provisioned."
}

variable location {
  type = string
  description = "Location where the node pool should be provisioned."
}

variable node_count {
  type = number
  description = "Number of nodes to provision in the pool."
}

variable machine_type {
  type = string
}

variable disk_size_gb {
  type = number
  description = "Size of disk to allocate for each node in the pool."
}

variable service_account {
  type = string
  default = null
  description = "Email of the SA that should run workloads in each pool. The default compute account will be used if not set."
}

variable enable_workload_identity {
  type = bool
  default = false
  description = "If true, enables k8s<->GCP SA linking for workloads in the pool. See: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity."
}

variable metadata {
  type = map(string)
  default = {
    google-compute-enable-virtio-rng = false,
    disable-legacy-endpoints = true
  }
}

variable labels {
  type = map(string)
  default = {}
}

variable tags {
  type = list(string)
  default = []
}