output name {
  value = google_container_cluster.cluster[0].name
}

output endpoint {
  value = google_container_cluster.cluster[0].endpoint
}

output ca_certificate {
  value = google_container_cluster.cluster[0].master_auth[0].cluster_ca_certificate
}
