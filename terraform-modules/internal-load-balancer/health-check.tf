

# GCE Load Balancer Health Check: Default - HTTP
resource "google_compute_health_check" "load-balancer-health-check" {
  provider = "google.target"
  name                  = "${var.load_balancer_name}-http"
  count                 = "${var.enable_flag}"
  check_interval_sec    = "${var.load_balancer_health_check_interval}"
  timeout_sec           = "${var.load_balancer_health_check_timeout}"
  healthy_threshold     = "${var.load_balancer_health_check_healthy_threshold}"
  unhealthy_threshold   = "${var.load_balancer_health_check_unhealthy_threshold}"
  https_health_check {
     port = "${var.load_balancer_health_check_port}"
     request_path          = "${var.load_balancer_health_check_path}"
  }
}

