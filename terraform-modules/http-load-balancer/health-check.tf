

# GCE Load Balancer Health Check: Default - HTTP
resource "google_compute_http_health_check" "load-balancer-health-check-http" {
  provider = "google.target"
  name                  = "${var.load_balancer_name}"
  count                 = "${var.enable_flag}"
  port                  = 80
  request_path          = "${var.load_balancer_health_check_path}"
  check_interval_sec    = "${var.load_balancer_health_check_interval}"
  timeout_sec           = "${var.load_balancer_health_check_timeout}"
  healthy_threshold     = "${var.load_balancer_health_check_healthy_threshold}"
  unhealthy_threshold   = "${var.load_balancer_health_check_unhealthy_threshold}"
}

# GCE Load Balancer Health Check: Default - HTTPS
resource "google_compute_https_health_check" "load-balancer-health-check-https" {
  provider = "google.target"
  name                  = "gce-lb-health-check-default-https"
  count                 = "${var.enable_flag}"
  port                  = 443
  request_path          = "${var.load_balancer_health_check_path}"
  check_interval_sec    = "${var.load_balancer_health_check_interval}"
  timeout_sec           = "${var.load_balancer_health_check_timeout}"
  healthy_threshold     = "${var.load_balancer_health_check_healthy_threshold}"
  unhealthy_threshold   = "${var.load_balancer_health_check_unhealthy_threshold}"
}

