data "google_client_config" "current" {}

provider "kubernetes" {
    load_config_file = false

    host  = "https://${var.gke_endpoint}"
    token = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(
        var.gke_ca_certificate,
    )
}

resource "kubernetes_namespace" "instance_namespace" {
    metadata {
        name = local.namespace
    }
}