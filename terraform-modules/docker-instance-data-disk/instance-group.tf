# data "google_compute_network" "app" {
#   name = "${var.instance_network_name}"
# }

resource "google_compute_instance_group" "instance-group-unmanaged" {
  provider = google.target
  project =  var.project
  count = var.enable_flag
  name        = var.instance_group_name == null ? "${var.instance_name}-instance-group-unmanaged" : var.instance_group_name
  description = "${var.instance_name} Instance Group - Unmanaged"

  instances = google_compute_instance.instance.*.self_link

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  zone = element(concat(google_compute_instance.instance.*.zone,list("")),0)

  depends_on = [ google_compute_instance.instance, var.dependencies ]
}
