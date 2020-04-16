
resource "google_compute_disk" "instance-data-disk" {
   provider = google.target
   project  = var.project
   count    = var.enable_flag == "1" ? var.instance_num_hosts : 0
   name     = format("%s-%02d-data-disk", var.instance_name, count.index + 1 + var.instance_count_offset)
   size     = var.instance_data_disk_size
   type     = var.instance_data_disk_type
   zone     = var.instance_zone
}
