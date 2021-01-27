# See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
variable dependencies {
  type        = any
  default     = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

variable project {
  type        = string
  description = "Google project"
  default     = null
}

variable name {
  type        = string
  description = "Name to assign to the master / GKE cluster."
}

variable location {
  type        = string
  description = "Zone or region to host the cluster. NOTE: passing a region here will give you a regional cluster with 3x the number of nodes."
}

variable version_prefix {
  type        = string
  description = "Version-prefix of k8s to use in the cluster (i.e. '1.14.')."
}

variable release_channel {
  type        = string
  description = "Release channel - RAPID, REGULAR, or STABLE"
  default     = "UNSPECIFIED"
}

variable network {
  type = string
}

variable subnetwork {
  type = string
}

# IP allocation policy for the cluster.
#
# The default forces GKE to allocate subnets for pods & services for us; this
# is for the sake of backwards compatibility. In general it is recommended to
# create secondary/alias ranges on the subnet and pass them in with
#   cluster_secondary_range_name  = "<name>"
#   services_secondary_range_name = "<name>"
#
# See docs for more details:
#   https://www.terraform.io/docs/providers/google/r/container_cluster.html#cluster_secondary_range_name
variable ip_allocation_policy {
  type        = map(string)
  description = "IP allocation policy"
  default     = {}
}

variable authorized_network_cidrs {
  type    = list(string)
  default = []
}

variable private_ipv4_cidr_block {
  type = string
}

variable enable_private_nodes {
  type    = bool
  default = true
}

variable enable_private_endpoint {
  type    = bool
  default = false
}

variable use_new_stackdriver_apis {
  type        = bool
  default     = true
  description = "If true, GKE's new APIs for logging / monitoring will be enabled. Otherwise legacy APIs will be used."
}

variable enable_workload_identity {
  type        = bool
  default     = false
  description = "If true, enables k8s<->GCP SA linking in the cluster. See: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity."
}

variable enable_shielded_nodes {
  type        = bool
  default     = false
  description = "If true, enables shielded nodes. https://cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes"
}

variable enable_binary_authorization {
  type    = bool
  default = false
}

variable database_encryption {
  description = "Application-layer Secrets Encryption settings. The object format is {state = string, key_name = string}. Valid values of state are: \"ENCRYPTED\"; \"DECRYPTED\". key_name is the name of a CloudKMS key."
  type        = list(object({ state = string, key_name = string }))

  default = [{
    state    = "DECRYPTED"
    key_name = ""
  }]
}
#
# Istio
#

variable istio_enable {
  type        = bool
  default     = false
  description = "Istio enable flag"
}

variable istio_auth {
  type        = string
  default     = "AUTH_NONE"
  description = "Istio auth mode"
}
