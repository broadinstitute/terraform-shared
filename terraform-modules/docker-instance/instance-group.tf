data "google_compute_network" "app" {
  name = "${var.instance_network_name}"
}

resource "google_compute_instance_group" "instance-group-unmanaged" {
    provider                = "google.target"
  project =  "${var.project}"
  count = "${var.enable_flag}"
  name        = "${var.instance_name}-instance-group-unmanaged"
  description = "${var.instance_name} Instance Group - Unmanaged"

  instances = "${google_compute_instance.instance.*.self_link}"

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  # zone = "${var.instance_zone}"
  zone = "${element(google_compute_instance.instance.*.zone,0)}"
  network = "${data.google_compute_network.app.self_link}"
  depends_on = [ "google_compute_instance.instance" ]
}
