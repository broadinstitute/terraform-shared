resource "google_monitoring_uptime_check_config" "uptime_check" {
  count = var.enabled ? 1 : 0

  display_name = local.check_name
  timeout      = var.timeout
}
