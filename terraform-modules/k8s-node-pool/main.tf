resource google_container_node_pool pool {
  provider = google-beta

  depends_on = [var.dependencies]
  name       = var.name
  location   = var.location
  cluster    = var.master_name

  # Scaling settings -- only one of node_count or autoscaling should be supplied
  node_count = var.node_count
  dynamic "autoscaling" {
    for_each = var.autoscaling == null ? [] : [var.autoscaling]

    min_node_count = autoscaling.min_node_count
    max_node_count = autoscaling.max_node_count
  }

  management {
    # CIS compliance: enable automatic repair
    auto_repair = true

    # CIS compliance: enable automatic upgrade
    auto_upgrade = true
  }

  upgrade_settings {
    max_unavailable = var.upgrade_settings.max_unavailable
    max_surge       = var.upgrade_settings.max_surge
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
    labels   = var.labels
    tags     = var.tags

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
