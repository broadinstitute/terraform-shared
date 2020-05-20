

variable "cloud_nat_name" {
  type    = string
  default = null
}

variable "cloud_nat_network" {
  type    = string
  default = "app-services"
}

variable "cloud_nat_subnetwork" {
  type    = string
  default = null
}

variable "cloud_nat_region" {
  type    = string
  default = "us-central1"
}

variable "cloud_nat_num_ips" {
  default = "1"
}

variable "cloud_nat_labels" {
  type        = map(string)
  default     = {}
  description = "label to apply to cloud-nat ip addressses"
}
