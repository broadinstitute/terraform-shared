

# GCE Load Balancer: Backend Services HTTPS 
resource "google_compute_region_backend_service" "load-balancer-backend-service-https" {
  provider    = "google.target"
  count       = "${var.enable_flag}"
  name        = "${var.load_balancer_name}-load-balancer-https"
  description = "Load Balancer GCE LB Backend Service - HTTPS"
  region      = "${var.load_balancer_region}"
  protocol    = "${var.load_balancer_protocol}"
#   timeout_sec = "${var.load_balancer_timeout}"

  backend {
    group = "${var.load_balancer_instance_groups}"
  }

  health_checks = google_compute_health_check.load-balancer-health-check.*.self_link
}


# GCE Load Balancer: Global Forwarding Rule HTTPS
resource "google_compute_forwarding_rule" "load-balancer-internal-lb-forwarding-rule" {
  provider              = "google.target"
  count                 = "${var.enable_flag}"
  name                  = "${var.load_balancer_name}"
  region                = "${var.load_balancer_region}"
  network               = "${var.load_balancer_network_name}"
  subnetwork            = "${var.load_balancer_subnetwork_name == ""?var.load_balancer_network_name:var.load_balancer_subnetwork_name}"
  load_balancing_scheme = "INTERNAL"
  backend_service       = "${var.enable_flag ? google_compute_region_backend_service.load-balancer-backend-service-https.0.self_link: ""}"
  ports                 = "${var.load_balancer_ports}"
  ip_address            = "${var.load_balancer_ip_address}"
}

