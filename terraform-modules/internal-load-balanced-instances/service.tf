provider "google" {
  alias = "instances"
}

# Docker instance(s)
module "instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance?ref=docker-instance-0.2.1-tf-0.12"

  providers = {
    google.target =  "google.instances"
  }
  project       = "${var.instance_project}"
  instance_name = "${var.service}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  instance_image = "${var.instance_image}"
  instance_service_account = "${data.google_service_account.config_reader.email}"
  instance_network_name = "${var.google_network_name}"
  instance_labels = {
    "app" = "${var.app_name_override != "" ? var.app_name_override : var.service}",
    "owner" = "${var.owner}",
    "ansible_branch" = "${var.ansible_branch}",
    "ansible_project" = "terra-env",
  }
  instance_tags = "${var.instance_tags}"
}

# Service config bucket
resource "google_storage_bucket" "config-bucket" {
  provider = "google.instances"
  count = "${var.config_bucket_enable}"
  name       = "${var.config_bucket_name != "" ? var.config_bucket_name : "${var.owner}-${var.service}-config"}"
  project    = "${var.instance_project}"
  versioning {
    enabled = "true"
  }
  # Do we want to add encryption to this bucket?
  force_destroy = true
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "config"
  }
}

# Grant service account access to the config bucket
resource "google_storage_bucket_iam_member" "app_config" {
  provider = "google.instances"
  count = "${var.config_bucket_enable == 0 ? 0 :length(var.storage_bucket_roles)}"
  bucket = "${var.config_bucket_enable == 0 ? "" : google_storage_bucket.config-bucket.0.name}"
  role   = "${element(var.storage_bucket_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.config_reader.email}"
}

# Load Balancer
#  need to figure out dependency in order to ensure proper order - instances 
#  must be created before load balancer
#  Potential solution: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534
module "load-balancer" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/internal-load-balancer?ref=http-load-balancer-0.3.2-tf-0.12"

  providers = {
    google.target =  "google.instances"
  }
  project       = "${var.instance_project}"
  load_balancer_name = "${var.owner}-${var.service}"
  load_balancer_health_check_path = "${var.load_balancer_health_check_path}"
  load_balancer_instance_groups = "${element(module.instances.instance_instance_group,0)}"
  load_balancer_network_name = "${var.google_network_name}"
  load_balancer_subnetwork_name = "${var.load_balancer_subnetwork_name}"
}
