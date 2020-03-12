resource google_monitoring_alert_policy cluster_alert {
  provider = google.target

  display_name = var.policy_name

  # Valid option are "AND" or "OR"
  combiner = var.condition_combine_method
  conditions {
    # The following must be specified per condition
    # Stackdriver enforces  maximum of six conditions per policy
    # Recommendation is use to use more policies with closely related conditions

    # name to be associated with the condition for display in gcloud
    display_name = var.condition_name

    condition_absent {
      # Specifiy condition behavior if metric data is missing
    } 

    condition_threshold {
      # Specify circumstances where alert is triggered
    }
  }

  enabled = true

  # An array of previously created notification_channel objects that should be alerted if a condition fails
  notification_channels = []
  user_labels = {
    # Key value pairs used for organizing alerting policies ie. by application
  }

  documentation {
    # Information to be displayed in a dashboard that provides more context for the alert
  }
}