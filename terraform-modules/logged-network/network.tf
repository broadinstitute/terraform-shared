resource "google_compute_network" "app-services" {          
  provider                = "google-beta.target"                                  
  name                    = "${var.network_name}"              
  depends_on              = ["module.enable-services"]                
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet-with-logging" {
  provider      = "google-beta.target"
  count         = length(var.subnet_cidrs)
  name          = var.network_name
  ip_cidr_range = var.subnet_cidrs[count.index].cidr
  region        = var.subnet_cidrs[count.index].region
  network       = "${google_compute_network.app-services.self_link}"

  enable_flow_logs = true
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling = 0.5
    metadata = "INCLUDE_ALL_METADATA"
  }
}
