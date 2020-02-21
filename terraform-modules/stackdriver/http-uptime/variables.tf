# Required Variables

variable "check_name" {
  type = string
  description = "Name assigned to new uptime check, must be unique" 
}

variable "url_path" {
  type = string
  description = "Path to endpoint the uptime check will hit"
}

variable "project" {
  type = string
  description = "project id for GCP project alert will be created in"
}

variable "domain_name" {
  type = string
  description = "Either domain or external ip of url to be checked"
}