# Unique per module, to group the resources
resource "random_id" "base-id" {
  byte_length = 4
}

# Additional name component for the runner to force
# recreation if metadata changes (which would normally
# not really take effect until a restart)
resource "random_id" "runner-id" {
  keepers = {
    role-id-path           = var.vault-role-id-path
    secret-id-path         = var.vault-secret-id-path
    vault-server           = var.vault-server
    github-pat-secret-path = var.github-personal-access-token-path
    repo                   = "broadinstitute/${var.repo}"
    runner-labels          = join(",", var.runner-labels)
    actions-user           = var.actions-user
  }

  byte_length = 4
}

# Create a static IP for each runner that won't change even
# if metadata or something else does
resource "google_compute_address" "static" {
  count = var.runners

  name = "gh-runner-${var.repo}-${random_id.base-id.hex}-ip-${count.index + 1}"
}

# Base the runner on latest Ubuntu
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

# Create each runner
resource "google_compute_instance" "runner" {
  count = var.runners

  name         = "gh-runner-${var.repo}-${random_id.base-id.hex}-${random_id.runner-id.hex}-${count.index + 1}"
  description  = "GitHub Actions runner ${count.index + 1} for broadinstitute/${var.repo}"
  machine_type = var.machine-type
  zone         = var.zone

  # Allow runners to go offline for TF `apply` but explicitly bring them back up after
  allow_stopping_for_update = true
  desired_status            = "RUNNING"

  service_account {
    email  = var.service-account
    scopes = var.service-account-scopes
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static[count.index].address
    }
  }

  boot_disk {
    initialize_params {
      size  = var.boot-disk-size
      image = data.google_compute_image.ubuntu.self_link
    }
    auto_delete = true
  }

  metadata = {
    role-id-path           = random_id.runner-id.keepers.role-id-path
    secret-id-path         = random_id.runner-id.keepers.secret-id-path
    vault-server           = random_id.runner-id.keepers.vault-server
    github-pat-secret-path = random_id.runner-id.keepers.github-pat-secret-path
    repo                   = random_id.runner-id.keepers.repo
    runner-labels          = random_id.runner-id.keepers.runner-labels
    actions-user           = random_id.runner-id.keepers.actions-user
    shutdown-script        = file("${path.module}/shutdown-script.sh")
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")
}
