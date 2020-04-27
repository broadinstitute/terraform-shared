resource "google_compute_network" "vpc-network" {          
  provider                = google-beta                                  
  name                    = var.network_name
  depends_on              = [module.enable-services]                
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each      = var.subnets

  provider                 = google-beta
  name                     = var.network_name
  network                  = google_compute_network.vpc-network.self_link
  region                   = each.key
  ip_cidr_range            = each.value.cidr
  private_ip_google_access = each.value.private_ip_access

  # until Google provider is at version 3.0+ we still need to supply enable_flow_logs 
  # value otherwise provider sets it to false and ignores the log_config block even 
  # though the deprecated message indicates otherwise
#  enable_flow_logs         = each.value.vpc_logging

  dynamic "log_config" {
    for_each = each.value.vpc_logging ? ["Placehold object so for_each works"] : []
    content {
      aggregation_interval = var.aggregation_interval
      flow_sampling        = var.flow_sampling
      metadata             = var.metadata
    }
  }
}

