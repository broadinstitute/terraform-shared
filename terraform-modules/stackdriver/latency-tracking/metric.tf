resource "google_logging_metric" "latency_metric" {
  for_each = local.final_computed_endpoints

  project     = var.google_project
  name        = "${var.service}-${var.environment}-${var.environment}-${each.key}-endpoint-latency"
  description = "Latency of ${var.service}'s ${each.key} endpoint in ${var.environment}"
  filter      = <<-EOT
    resource.type="http_load_balancer" AND
    resource.labels.project_id="${var.google_project}" AND
    httpRequest.requestUrl=~"${each.value.computed_regex}"
  EOT

  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "DISTRIBUTION"
    unit         = "s"
    display_name = "Latency for ${var.service} ${each.key} in ${var.environment}"
  }

  value_extractor = "REGEXP_EXTRACT(httpRequest.latency, \"([0-9.]+)\")"

  # Only used for histogram view, required for DISTRIBUTION type, these are Google's defaults
  bucket_options {
    exponential_buckets {
      num_finite_buckets = 64
      growth_factor      = 2
      scale              = 0.01
    }
  }
}
