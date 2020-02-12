resource google_container_node_pool pool {

  provider   = google-beta.target
  project    = var.project
  depends_on = [var.dependencies]
  name       = var.name
  location   = var.location
  cluster    = var.master_name
  node_count = "${var.enable_flag == "1"?var.node_count:0}"

  management {
    # CIS compliance: enable automatic repair
    auto_repair = true

    # CIS compliance: enable automatic upgrade
    auto_upgrade = true
  }

  node_config {
    # CIS compliance: COS image
    image_type      = "COS"
    machine_type    = var.machine_type
    disk_size_gb    = var.disk_size_gb
    service_account = var.service_account

    # Protect node metadata
    workload_metadata_config {
      # Workload Identity only works when using the metadata server.
      node_metadata = var.enable_workload_identity ? "GKE_METADATA_SERVER" : "SECURE"
    }

    metadata = var.metadata
    labels = var.labels
    tags   = var.tags

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
