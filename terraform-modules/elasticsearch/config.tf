resource "google_storage_bucket_object" "docker-compose" {
  count = var.num_hosts
  name   = "${element(split("/", element(module.instances.instance_names, count.index)), length(split("/", element(module.instances.instance_names, count.index))) - 1)}/configs/docker-compose.yaml"
  content = <<EOT
version: '2'
services:
  app:
    image: broadinstitute/elasticsearch:5.4.0_6
    logging:
      driver: syslog
      options:
        tag: "elastic-node"
    restart: always
    ulimits:
      memlock: -1
      nofile: 65536
    environment:
      - bootstrap.memory_lock=true
      - network.bind_host=_eth0_
      - network.publish_host=${data.null_data_source.hostnames_with_no_trailing_dot[count.index].outputs.hostname_priv}
      - network.host=${data.null_data_source.hostnames_with_no_trailing_dot[count.index].outputs.hostname_priv}
      - http.cors.allow-origin='*'
      - http.cors.enabled=true
      - node.name=${module.instances.instance_names[count.index]}
      - xpack.security.enabled=false
      - xpack.graph.enabled=false
      - xpack.ml.enabled=false
      - xpack.monitoring.enabled=false
      - xpack.watcher.enabled=false
    cap_add:
      - IPC_LOCK
    ports:
      - "9200:9200"
      - "9300:9300"
    volumes:
      - ${var.application_data_path}:/usr/share/elasticsearch/data
EOT
  bucket = "${google_storage_bucket.config-bucket.name}"
  depends_on = [ data.null_data_source.hostnames_with_no_trailing_dot, module.instances, google_storage_bucket.config-bucket]
}
