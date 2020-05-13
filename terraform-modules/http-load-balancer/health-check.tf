resource "google_compute_health_check" "http" {
  provider            = google.target
  count               = var.enable_flag

  name        = "${var.load_balancer_name}-http"
  description = "Health check via http"

  timeout_sec         = var.load_balancer_health_check_timeout
  check_interval_sec  = var.load_balancer_health_check_interval
  healthy_threshold   = var.load_balancer_health_check_healthy_threshold
  unhealthy_threshold = var.load_balancer_health_check_unhealthy_threshold

  http_health_check {
    port               = 80
    request_path       = var.load_balancer_health_check_path
  }
}

resource "google_compute_health_check" "https" {
  provider            = google.target
  count               = var.enable_flag

  name        = "${var.load_balancer_name}-https"
  description = "Health check via https"

  timeout_sec         = var.load_balancer_health_check_timeout
  check_interval_sec  = var.load_balancer_health_check_interval
  healthy_threshold   = var.load_balancer_health_check_healthy_threshold
  unhealthy_threshold = var.load_balancer_health_check_unhealthy_threshold

  https_health_check {
    port               = 443
    request_path       = var.load_balancer_health_check_path
  }
}
