locals {
  # First, we contend with dashboard's indexing.
  # - We have an unordered map of endpoints
  # - Terraform only allows indexes to be derived from lists (no counted loops still, but `index` works)
  # - We assemble a list of lexicographically sorted endpoint names, putting the ones with alerts first
  ordered_endpoints = concat(
    sort([for name, config in local.final_computed_endpoints : name if config.enable_alerts]),
    sort([for name, config in local.final_computed_endpoints : name if ! config.enable_alerts])
  )
  # Second, we assemble a heatmap widget for every endpoint.
  # - This is the graph that appears regardless of whether alerting is enabled
  # - If alerting is enabled, we add the threshold as a line
  # - We associate the JSON snippet to the endpoint name so we can grab it later
  # - Not a ton of configuration here because there's a button to open it up in the explorer
  #   where you can poke around the data
  heatmap_widgets = {
    for name, config in local.final_computed_endpoints : name => <<EOT
          "title": "Latency: ${var.service} ${name} in ${var.environment}",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "HEATMAP",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/${google_logging_metric.latency_metric[name].name}\" AND resource.type=\"l7_lb_rule\""
                  }
                }
              }
            ],
            ${config.enable_alerts ? <<EOTnested
            "thresholds": [
              {
                "label": "alert threshold",
                "targetAxis": "Y1",
                "value": ${config.alert_threshold_milliseconds / 1000}
              }
            ],
EOTnested
  : "\"thresholds\": [],"}
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
EOT
}

# Third, we assemble an alert view widget or a text view widget for each endpoint
# - If the endpoint has alerting enabled, grab a graph showing that specific alert condition
# - If not, add a text widget noting that to avoid confusion
alert_widgets = {
  for name, config in local.final_computed_endpoints : name => config.enable_alerts ? <<EOT
          "alertChart": {
            "name": "${google_monitoring_alert_policy.latency_alert[name].name}"
          }
EOT
  : <<EOT
          "text": {
            "content": "If you'd like to add an alert targeting this endpoint (`${replace(config.computed_regex, "\\", "\\\\")}`), you can do so wherever ${var.service}-${var.environment}'s [latency-tracking](https://github.com/broadinstitute/terraform-shared/tree/master/terraform-modules/stackdriver/latency-tracking) module is instantiated.",
            "format": "MARKDOWN"
          },
          "title": "No latency alert configured for ${var.service} ${name} in ${var.environment}"
EOT
}

# Fourth, we finally assemble a list of all tiles, each containing a widget and position info
# - The order of the tiles in the JSON technically doesn't matter, but the xPos and yPos do
# - We iterate over the ordered list to keep the execution order stable
# - We still have to call `index` to get the actual numerical index
# - We leave off the trailing comma so it can be added as the separator
#   (so we don't have an actual trailing comma in the JSON)
tiles = [
  for name in local.ordered_endpoints : <<EOT
      {
        "height": 1,
        "widget": {
${local.heatmap_widgets[name]}
        },
        "width": 1,
        "xPos": 0,
        "yPos": ${index(local.ordered_endpoints, name)}
      },
      {
        "height": 1,
        "widget": {
${local.alert_widgets[name]}
        },
        "width": 1,
        "xPos": 1,
        "yPos": ${index(local.ordered_endpoints, name)}
      }
EOT
]

# Last, we can join the list of tiles and add the surrounding JSON
dashboard = <<EOT
{
  "category": "CUSTOM",
  "displayName": "${var.service}-${var.environment}-endpoint-latency",
  "mosaicLayout": {
    "columns": 2,
    "tiles": [
${join(",\n", local.tiles)}
    ]
  }
}
EOT
}

resource "google_monitoring_dashboard" "latency_dashboard" {
  count = length(local.final_computed_endpoints) > 0 ? 1 : 0

  project        = var.google_project
  dashboard_json = local.dashboard
}
