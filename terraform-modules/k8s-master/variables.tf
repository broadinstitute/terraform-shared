# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable dependencies {
  type = any
  default = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

variable name {
  type = string
  description = "Name to assign to the master / GKE cluster."
}

variable location {
  type = string
  description = "Zone or region to host the cluster. NOTE: passing a region here will give you a regional cluster with 3x the number of nodes."
}

variable version_prefix {
  type = string
  description = "Version-prefix of k8s to use in the cluster (i.e. '1.14.')."
}

variable network {
  type = string
}

variable subnetwork {
  type = string
}

variable authorized_network_cidrs {
  type = list(string)
}

variable private_ipv4_cidr_block {
  type = string
}

variable enable_private_nodes {
  type = bool
  default = true
}

variable enable_private_endpoint {
  type = bool
  default = false
}

variable use_new_stackdriver_apis {
  type = bool
  default = true
  description = "If true, GKE's new APIs for logging / monitoring will be enabled. Otherwise legacy APIs will be used."
}

variable enable_workload_identity {
  type = bool
  default = false
  description = "If true, enables k8s<->GCP SA linking in the cluster. See: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity."
}
