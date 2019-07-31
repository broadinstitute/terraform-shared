/*
* Kubernetes Cluster
*/

resource "google_container_cluster" "cluster" {
  provider = google
  name     = var.cluster_name
  zone     = var.zone

  network    = var.cluster_network
  subnetwork = var.cluster_subnetwork

  # CIS compliance: stackdriver logging
  logging_service = "logging.googleapis.com"

  # CIS compliance: stackdriver monitoring
  monitoring_service = "monitoring.googleapis.com"

  # Defines the minimum version allowed for the K8s master
  min_master_version = var.master_version

  # CIS compliance: disable legacy Auth
  enable_legacy_abac = false

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
  node_pool {
    name = "default-pool"
  }

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

  # CIS compliance: Enable Alias IP Ranges. According to the terrafform
  # docs, setting these values blank gets default-size ranges automatically
  # chosen: https://www.terraform.io/docs/providers/google/r/container_cluster.html#ip_allocation_policy
  dynamic "ip_allocation_policy" {
    for_each = [var.ip_allocation_policy]
    iterator = "policy"
    content {
      cluster_ipv4_cidr_block = policy.cluster_ipv4_cidr_block
      cluster_secondary_range_name = policy.cluster_secondary_range_name
      create_subnetwork = policy.create_subnetwork
      node_ipv4_cidr_block = policy.node_ipv4_cidr_block
      services_ipv4_cidr_block = policy.services_ipv4_cidr_block
      services_secondary_range_name = policy.services_secondary_range_name
      subnetwork_name = policy.subnetwork_name
      use_ip_aliases = policy.use_ip_aliases
    }
  }

  # CIS compliance: Enable PodSecurityPolicyController
  pod_security_policy_config {
    enabled = true
  }

  # OMISSION: CIS compliance: Enable Private Cluster
  dynamic "private_cluster_config" {
    for_each = [var.private_cluster_config]
    iterator = "config"
    content {
      enable_private_endpoint = config.enable_private_endpoint
      enable_private_nodes = config.enable_private_nodes
      master_ipv4_cidr_block = config.master_ipv4_cidr_block
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = [var.master_authorized_network_cidrs]
      content {
        cidr_block = cidr_blocks.value
      }
    }
  }

  addons_config {
    kubernetes_dashboard {
      # CIS compliance: Disable dashboard
      disabled = true
    }

    network_policy_config {
      disabled = false
    }
  }
}

output "cluster_name" {
  value = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.cluster.endpoint
}
