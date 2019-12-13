# Pass variables through to nested modules.

module "master" {
  source = "../k8s-master"
  dependencies = var.dependencies
  name = var.cluster_name
  location = var.location
  version_prefix = var.k8s_version
  network = var.cluster_network
  subnetwork = var.cluster_subnetwork
  authorized_network_cidrs = var.master_authorized_network_cidrs
  private_ipv4_cidr_block = var.private_master_ipv4_cidr_block
  enable_private_nodes = var.enable_private_nodes
  enable_private_endpoint = var.enable_private_endpoint
  use_new_stackdriver_apis = var.use_new_stackdriver_apis
  enable_workload_identity = var.enable_workload_identity
}

module "node-pool" {
  source = "../k8s-node-pool"
  dependencies = var.dependencies
  name = "${var.cluster_name}-np"
  master_name = module.master.name
  location = var.location
  node_count = var.node_pool_count
  machine_type = var.node_pool_machine_type
  disk_size_gb = var.node_pool_disk_size_gb
  service_account = var.node_service_account
  enable_workload_identity = var.enable_workload_identity
  metadata = var.node_metadata
  labels = var.node_labels
  tags = var.node_tags
}
