resource "google_compute_address" "static" {
  provider = google.default
  count    = var.runners

  name = "github-runner-${var.repo}-${count.index + 1}-ip"
}

data "google_compute_image" "debian" {
  provider = google.default

  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_instance" "runner" {
  provider   = google.default
  depends_on = [google_compute_address.static]
  count      = var.runners

  name                      = "github-runner-${var.repo}-${count.index + 1}"
  description               = "GitHub Actions runner ${count.index + 1} for broadinstitute/${var.repo}"
  machine_type              = var.machine-type
  zone                      = var.zone
  allow_stopping_for_update = true

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
      image = data.google_compute_image.debian.self_link
    }
    auto_delete = true
  }

  metadata {
    role-id-path           = var.vault-role-id-path
    secret-id-path         = var.vault-secret-id-path
    github-pat-secret-path = var.github-personal-access-token-path
    repo                   = "broadinstitute/${var.repo}"
    shutdown-script        = file("${path.module}/shutdown-script.sh")
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")
}
