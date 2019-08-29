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
      - network.publish_host=${substr(element(google_dns_record_set.dns-a-priv.*.name, count.index), 0, length(element(google_dns_record_set.dns-a-priv.*.name, count.index)) - 1)}
      - network.host=${substr(element(google_dns_record_set.dns-a-priv.*.name, count.index), 0, length(element(google_dns_record_set.dns-a-priv.*.name, count.index)) - 1)}
      - node.name=${module.instances.instance_names[count.index]}
      - cluster.name=${var.owner}-${var.service}
      - discovery.zen.ping.unicast.hosts=${join(",", substr(google_dns_record_set.dns-a-priv.*.name, 0, length(google_dns_record_set.dns-a-priv.*.name) - 1))}
      - bootstrap.memory_lock=true
      - network.bind_host=_eth0_
      - http.cors.allow-origin='*'
      - http.cors.enabled=true
      - xpack.security.enabled=false
      - xpack.graph.enabled=false
      - xpack.ml.enabled=false
      - xpack.monitoring.enabled=false
      - xpack.watcher.enabled=false
      - ES_JAVA_OPTS=-Xms${var.java_xms} -Xmx${var.java_xmx}
    cap_add:
      - IPC_LOCK
    ports:
      - "9200:9200"
      - "9300:9300"
    volumes:
      - ${var.application_data_path}:/usr/share/elasticsearcih/data
EOT
  bucket = "${google_storage_bucket.config-bucket.name}"
  depends_on = [ module.instances, google_storage_bucket.config-bucket, google_dns_record_set.dns-a-priv ]
}
