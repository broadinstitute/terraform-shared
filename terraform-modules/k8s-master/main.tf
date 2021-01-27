# Needed for getting the latest valid master version in the target location.
# This lets us do fuzzy version specs (i.e. '1.14.' instead of '1.14.5-gke.10')
data google_container_engine_versions cluster_versions {
  location       = var.location
  version_prefix = var.version_prefix
}

resource google_container_cluster cluster {
  provider = google-beta

  name       = var.name
  location   = var.location
  depends_on = [var.dependencies]

  network    = var.network
  subnetwork = var.subnetwork

  # CIS compliance: stackdriver logging
  logging_service = var.use_new_stackdriver_apis ? "logging.googleapis.com/kubernetes" : "logging.googleapis.com"

  # CIS compliance: stackdriver monitoring
  monitoring_service = var.use_new_stackdriver_apis ? "monitoring.googleapis.com/kubernetes" : "monitoring.googleapis.com"

  min_master_version = data.google_container_engine_versions.cluster_versions.latest_master_version

  release_channel {
    channel = var.release_channel
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      master_auth[0].client_certificate_config[0].issue_client_certificate,
      network,
      subnetwork,
    ]
  }


  # Silly, but necessary to have a default pool of 0 nodes. This allows the node definition to be handled cleanly
  # in a separate file
  remove_default_node_pool = true
  initial_node_count = 1

  dynamic "database_encryption" {
    for_each = var.database_encryption

    content {
      key_name = database_encryption.value.key_name
      state    = database_encryption.value.state
    }
  }

  # CIS compliance: disable legacy Auth
  enable_legacy_abac = false

  # CIS compliance: disable basic auth -- this creates a certificate and
  # disables basic auth by not specifying a user / pasword.
  # See https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_auth
  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
    username = ""
    password = ""
  }

  # CIS compliance: Enable Network Policy
  network_policy {
    enabled = true
  }

  # Set IP allocation policy based on variable.
  ip_allocation_policy {
    cluster_ipv4_cidr_block       = lookup(var.ip_allocation_policy, "cluster_ipv4_cidr_block", null)
    services_ipv4_cidr_block      = lookup(var.ip_allocation_policy, "services_ipv4_cidr_block", null)
    cluster_secondary_range_name  = lookup(var.ip_allocation_policy, "cluster_secondary_range_name", null)
    services_secondary_range_name = lookup(var.ip_allocation_policy, "services_secondary_range_name", null)
  }

  # CIS compliance: Enable PodSecurityPolicyController
  pod_security_policy_config {
    enabled = true
  }

  dynamic "workload_identity_config" {
    for_each = var.enable_workload_identity ? ["Placeholder value to force the loop to iterate once"] : []
    content {
      identity_namespace = "${var.project}.svc.id.goog"
    }
  }

  # CIS compliance: shielded nodes, binary authorization
  enable_shielded_nodes       = var.enable_shielded_nodes
  enable_binary_authorization = var.enable_binary_authorization


  # OMISSION: CIS compliance: Enable Private Cluster
  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.private_ipv4_cidr_block
  }


  dynamic "master_authorized_networks_config" {
    for_each = length(var.authorized_network_cidrs) != 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.authorized_network_cidrs
        content {
          cidr_block = cidr_blocks.value
        }
      }
    }
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
    istio_config {
      disabled = ! var.istio_enable
      auth     = var.istio_auth
    }
  }
}
