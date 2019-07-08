resource "google_compute_instance_group" "instance-group-unmanaged" {
    provider                = "google.target"
  count = "${var.enable_flag}"
  name        = "${var.instance_name}-instance-group-unmanaged"
  description = "${var.instance_name} Instance Group - Unmanaged"

  instances = [ "${google_compute_instance.instance.*.self_link}" ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  zone = "${var.instance_zone}"
  network = "${var.instance_network_name}"
  depends_on = [ "google_compute_instance.instance" ]
}
