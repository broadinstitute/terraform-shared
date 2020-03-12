resource google_monitoring_alert_policy cluster_alert {
  provider = google.target

  display_name = var.policy_name

  # Valid option are "AND" or "OR"
  combiner = var.condition_combine_method
  conditions {
    
  }

}