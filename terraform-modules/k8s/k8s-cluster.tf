/*
* Kubernetes Cluster
*/

resource "google_container_cluster" "cluster" {
  provider            = "google"
  name                = "${var.cluster_name}"
  zone                = "${var.zone}"

  network             = "${var.cluster_network}"
  subnetwork          = "${var.cluster_subnetwork}"

  # CIS compliance: stackdriver logging
  logging_service     = "logging.googleapis.com"
  # CIS compliance: stackdriver monitoring
  monitoring_service  = "monitoring.googleapis.com"

  # Defines the minimum version allowed for the K8s master
  min_master_version  = "${var.master_version}"

  # CIS compliance: disable legacy Auth
  enable_legacy_abac  = "false"

  lifecycle {
    ignore_changes  = [
      "node_pool"
    ]
  }

  # Silly, but necessary to have a default pool of 0 nodes. This allows the node definition to be handled cleanly
  # in a separate file
  node_pool {
    name            = "default-pool"
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
  ip_allocation_policy {
    cluster_ipv4_cidr_block = ""
    services_ipv4_cidr_block = ""
  }

  # CIS compliance: Enable PodSecurityPolicyController
  pod_security_policy_config {
    enabled = true
  }

  # OMISSION: CIS compliance: Enable Private Cluster 
  /*
  private_cluster_config {
    enable_private_nodes = true
    master_ipv4_cidr_block =  "${var.master_ipv4_cidr_block}"
  }
  */


  master_authorized_networks_config {
    cidr_blocks = ["${var.master_authorized_network_cidrs}"]
  }

  addons_config {
    kubernetes_dashboard {
      # CIS compliance: Disable dashboard
      disabled    = "true"
    }
  }
}
