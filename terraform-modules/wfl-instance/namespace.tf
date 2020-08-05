data "google_client_config" "current" {}

data "google_container_cluster" "cluster" {
    depends_on = [var.depends_on_cluster]
    name       = var.cluster_name
    location   = var.cluster_location
}

provider "kubernetes" {
    load_config_file = false

    host  = "https://${data.google_container_cluster.cluster.endpoint}"
    token = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(
        data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
    )
}

resource "kubernetes_namespace" "instance_namespace" {
    metadata {
        name = locals.namespace
    }
}