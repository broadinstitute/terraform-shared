#
# Profile Vars
#
variable "instance_project" {
  description = "The google project as specified in the application json"
}
variable "dns_zone_name" {
  description = "The full DNS zone without a trailing . as specified in the application json"
}
variable "owner" {
  description = "The owner from the application json"
}
variable "service" {
  description = "The name of the service within the profile"
}

#
# Dependency Profiles' Vars
#
# DNS
variable "dns_project" {}

# SSL
variable "ssl_policy_name" {}
variable "google_compute_ssl_certificate_red" {}
variable "google_compute_ssl_certificate_black" {}
data "google_compute_ssl_certificate" "terra-env-wildcard-ssl-certificate-red" {
  name = "${var.google_compute_ssl_certificate_red}"
}
data "google_compute_ssl_certificate" "terra-env-wildcard-ssl-certificate-black" {
  name = "${var.google_compute_ssl_certificate_black}"
}
# Network
variable "google_network_name" {
}

# Name of SA to be given read access to config bucket
variable "config_reader_service_account" {
}
data "google_service_account" "config_reader" {
  account_id = "${var.config_reader_service_account}"
}

#
# Load balancer
#
variable "lb_health_check" {
  description = "The default load balancer health check"
  default = "/status"
}

#
# Service Cluster 
#
variable "instance_num_hosts" {
  description = "The default number of Service service hosts per environment"
}

variable "instance_size" {
  description = "The default size of Service service hosts"
}

variable "instance_tags" {
  type = "list"
  description = "The default instance tags"
}

variable "instance_image" {
  default = "centos-7"
  description = "Image used to build instance"
}

variable "ansible_branch" {
  description = "The branch of dsp-ansible-configs to use when provisioning"
  default = "master"
}

#
# Service Config Bucket
#
variable "storage_bucket_roles" {
  type = "list"

  default = [
    "roles/storage.legacyBucketReader",
    "roles/storage.objectViewer"
  ]
}

variable "dns_ttl" {
   default = "300"
}
