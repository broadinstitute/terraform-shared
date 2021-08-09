resource google_container_node_pool pool {
  provider = google-beta

  count = var.enable ? 1 : 0

  depends_on        = [var.dependencies]
  name              = var.name
  location          = var.location
  cluster           = var.master_name
  max_pods_per_node = var.max_pods_per_node

  # Scaling settings -- only one of node_count or autoscaling should be supplied
  node_count = var.node_count

  # When using autoscaling, initial_node_count must be set, otherwise
  # an empty node pool is created, even if the minimum is > 0
  # (See https://github.com/hashicorp/terraform-provider-google/issues/2126)
  initial_node_count = var.autoscaling == null ? null : var.autoscaling.min_node_count

  dynamic "autoscaling" {
    for_each = var.autoscaling == null ? [] : [var.autoscaling]

    content {
      min_node_count = autoscaling.value["min_node_count"]
      max_node_count = autoscaling.value["max_node_count"]
    }
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
    image_type      = var.image_type
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

    taint = var.taints

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }
  }
  # Ignore changes to taints. We set them up at pool creation time, but don't
  # update them afterwards, because it could trigger node pool recreation and cause
  # an outage. See
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#taint
  lifecycle {
    ignore_changes = [node_config[0].taint]
  }
}
