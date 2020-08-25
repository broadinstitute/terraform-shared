
# GCE Load Balancer: Public IP Address
resource "google_compute_global_address" "load-balancer-pub-ip" {
  provider = google.target
  count    = var.enable_flag
  name     = "${var.load_balancer_name}-pub-ip"
}

# GCE Load Balancer: Backend Services HTTPS 
resource "google_compute_backend_service" "load-balancer-backend-service-https" {
  provider                        = google.target
  count                           = var.enable_flag
  name                            = "${var.load_balancer_name}-load-balancer-https"
  description                     = "Load Balancer GCE LB Backend Service - HTTPS"
  port_name                       = "https"
  protocol                        = "HTTPS"
  timeout_sec                     = 120
  enable_cdn                      = false
  connection_draining_timeout_sec = 120

  backend {
    group = var.load_balancer_instance_groups
  }

  security_policy = length(var.load_balancer_rules) != 0 ? google_compute_security_policy.policy[0].self_link : null

  health_checks = google_compute_health_check.https.*.self_link
}

# GCE Load Balancer: URL Maps HTTPS
resource "google_compute_url_map" "load-balancer-url-map-https" {
  provider    = google.target
  count       = var.enable_flag
  name        = "${var.load_balancer_name}-load-balancer-https"
  description = "Load Balancer URL Map - HTTPS - All Paths"

  default_service = var.enable_flag == 0 ? "" : google_compute_backend_service.load-balancer-backend-service-https.0.self_link
}

# GCE Load Balancer: Target Proxies HTTPS
resource "google_compute_target_https_proxy" "load-balancer-target-proxy-https" {
  provider         = google.target
  count            = var.enable_flag
  name             = "${var.load_balancer_name}-load-balancer"
  description      = "Load Balancer Target Proxy - HTTPS"
  url_map          = var.enable_flag == 0 ? "" : google_compute_url_map.load-balancer-url-map-https.0.self_link
  ssl_certificates = var.load_balancer_ssl_certificates
  ssl_policy       = var.load_balancer_ssl_policy_enable == 1 ? var.ssl_policy_name : ""
}


# GCE Load Balancer: Global Forwarding Rule HTTPS
resource "google_compute_global_forwarding_rule" "load-balancer-global-forwarding-rule-https" {
  provider   = google.target
  count      = var.enable_flag
  name       = var.load_balancer_name
  target     = var.enable_flag == 0 ? "" : google_compute_target_https_proxy.load-balancer-target-proxy-https.0.self_link
  ip_address = var.enable_flag == 0 ? "" : google_compute_global_address.load-balancer-pub-ip.0.address
  port_range = "443"
}
