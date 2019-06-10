
# GCE Load Balancer: Public IP Address
resource "google_compute_global_address" "load-balancer-pub-ip" {
  provider = "google.target"
  count    = "${var.enable_flag}"
  name     = "${var.load_balancer_name}-pub-ip"
}

# GCE Load Balancer: Backend Services HTTPS 
resource "google_compute_backend_service" "load-balancer-backend-service-https" {
  provider = "google.target"
  count = "${var.enable_flag}"
  name = "${var.load_balancer_name}-load-balancer-backend-service-https"
  description = "Load Balancer GCE LB Backend Service - HTTPS"
  port_name = "https"
  protocol = "HTTPS"
  timeout_sec = 120
  enable_cdn = false
  connection_draining_timeout_sec = 120

  backend {
    group = "${var.load_balancer_instance_groups}"
  }

  health_checks = ["${google_compute_https_health_check.load-balancer-health-check-https.self_link}"]
}

# GCE Load Balancer: URL Maps HTTPS
resource "google_compute_url_map" "load-balancer-url-map-https" {
  provider = "google.target"
  count = "${var.enable_flag}"
  name = "${var.load_balancer_name}-load-balancer-100-url-map-https"
  description = "Load Balancer URL Map - HTTPS - All Paths"

  default_service = "${google_compute_backend_service.load-balancer-backend-service-https.self_link}"
}

# GCE Load Balancer: Target Proxies HTTPS
resource "google_compute_target_https_proxy" "load-balancer-target-proxy-https" {
  provider = "google.target"
  count = "${var.enable_flag}"
  name = "${var.load_balancer_name}-load-balancer-100-target-proxy-https"
  description = "Load Balancer Target Proxy - HTTPS"
  url_map = "${google_compute_url_map.load-balancer-url-map-https.self_link}"
  ssl_certificates = ["${var.load_balancer_ssl_certificates}"]
  ssl_policy = "${var.load_balancer_ssl_policy_enable == "1" ? var.load_balancer_ssl_policy: "" }"
}


# GCE Load Balancer: Global Forwarding Rule HTTPS
resource "google_compute_global_forwarding_rule" "load-balancer-global-forwarding-rule-https" {
  provider = "google.target"
  count = "${var.enable_flag}"
  name = "${var.load_balancer_name}-load-balancer-global-forwarding-rule-https"
  target = "${google_compute_target_https_proxy.load-balancer-target-proxy-https.self_link}"
  ip_address = "${google_compute_global_address.load-balancer-pub-ip.address}"
  port_range = "443"
}

