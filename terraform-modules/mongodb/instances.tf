
# Docker instance(s)
module "instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance-data-disk?ref=docker-instance-data-disk-0.2.6"

  providers = {
    google.target = google.target
  }
  project       = var.project
  instance_name = var.service
  instance_num_hosts = length(var.mongodb_roles)
  instance_size = var.instance_size
  instance_image = var.instance_image
  instance_count_offset = var.instance_count_offset
  instance_group_name = var.instance_group_name
  instance_data_disk_size = var.instance_data_disk_size
  instance_data_disk_type = var.instance_data_disk_type
  instance_data_disk_name = var.instance_data_disk_name
  instance_service_account = var.mongodb_service_account
  instance_network_name = var.instance_network_name
  instance_labels = var.instance_labels
  instance_tags = var.instance_tags

  dependencies = [var.dependencies]
}
