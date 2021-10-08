output "dashboard_url" {
  value = (
    length(local.final_computed_endpoints) > 0
    ? "https://console.cloud.google.com/monitoring/dashboards/builder/${element(split("/", google_monitoring_dashboard.latency_dashboard[0].id), 3)}?project=${var.google_project}"
    : null
  )
  description = "The URL of the created dashboard, or null if no endpoints are being tracked."
}
