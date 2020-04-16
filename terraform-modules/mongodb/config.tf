resource "google_storage_bucket_object" "docker-compose-clustered" {
  count = length(var.mongodb_roles) > 1 ? length(var.mongodb_roles) : 0
  name   = "${element(split("/", element(module.instances.instance_names, count.index)), length(split("/", element(module.instances.instance_names, count.index))) - 1)}/configs/docker-compose.yaml"
  content = <<EOT
version: '2'
services:
  mongodb:
    image: bitnami/mongodb:${var.mongodb_image_tag}
    ports:
      - "${var.mongodb_host_port}:${var.mongodb_container_port}"
    environment:
      - ${var.mongodb_roles[count.index] == "primary" ? "MONGODB_ROOT_PASSWORD=${var.mongodb_root_password}" : "MONGODB_PRIMARY_ROOT_PASSWORD=${var.mongodb_root_password}"}
      - MONGODB_USERNAME=${var.mongodb_app_username}
      - MONGODB_PASSWORD=${var.mongodb_app_password}
      - MONGODB_DATABASE=${var.mongodb_database}
      - MONGODB_PORT_NUMBER=${var.mongodb_container_port}
      - MONGODB_PRIMARY_PORT_NUMBER=${var.mongodb_container_port}
      - MONGODB_REPLICA_SET_MODE=${element(var.mongodb_roles, count.index)}
      - MONGODB_REPLICA_SET_KEY=${var.mongodb_replica_set_key}
      - MONGODB_ADVERTISED_HOSTNAME=${length(data.null_data_source.hostnames_with_no_trailing_dot) > 0 ? data.null_data_source.hostnames_with_no_trailing_dot[count.index].outputs.hostname_priv : ""}
      ${var.mongodb_roles[count.index] == "primary" ? "" : "- MONGODB_PRIMARY_HOST=${length(data.null_data_source.hostnames_with_no_trailing_dot) > 0 ? data.null_data_source.hostnames_with_no_trailing_dot[0].outputs.hostname_priv : ""}"}
      ${var.mongodb_extra_flags == null ? "" : "- MONGODB_EXTRA_FLAGS=${var.mongodb_extra_flags}"}
    volumes:
      - ${var.mongodb_data_path}:/bitnami
    restart: always
    logging:
      driver: gcplogs
EOT
  bucket = google_storage_bucket.config-bucket.name
  depends_on = [
    module.instances,
    google_storage_bucket.config-bucket,
    data.null_data_source.hostnames_with_no_trailing_dot
  ]
}

resource "google_storage_bucket_object" "docker-compose" {
  count = length(var.mongodb_roles) == 1 ? length(var.mongodb_roles) : 0
  name   = "${element(split("/", element(module.instances.instance_names, count.index)), length(split("/", element(module.instances.instance_names, count.index))) - 1)}/configs/docker-compose.yaml"
  content = <<EOT
version: '2'
services:
  mongodb:
    image: bitnami/mongodb:${var.mongodb_image_tag}
    ports:
      - "${var.mongodb_host_port}:${var.mongodb_container_port}"
    environment:
      - MONGODB_ROOT_PASSWORD=${var.mongodb_root_password}
      - MONGODB_USERNAME=${var.mongodb_app_username}
      - MONGODB_PASSWORD=${var.mongodb_app_password}
      - MONGODB_DATABASE=${var.mongodb_database}
      - MONGODB_PORT_NUMBER=${var.mongodb_container_port}
      ${var.mongodb_extra_flags == null ? "" : "- MONGODB_EXTRA_FLAGS=${var.mongodb_extra_flags}"}
    volumes:
      - ${var.mongodb_data_path}:/bitnami
    restart: always
    logging:
      driver: gcplogs
EOT
  bucket = google_storage_bucket.config-bucket.name
  depends_on = [
    module.instances,
    google_storage_bucket.config-bucket
  ]
}
