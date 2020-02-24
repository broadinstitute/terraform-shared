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

# Optional Variables

variable "check_timeout" {
  type = string 
  default = "30s"
  description = "Period after which check will automatically fail"
}

variable "check_frequency" {
  type = string
  default = "60s"
  description = "How often check will occur. Valid inputs are 60s, 300s, 600s, and 900s"
}

variable "port" {
  type = string
  default = "80"
  description = "Port to be used in uptime check"
}

variable "https_enabled" {
  type = bool
  default = false
  description = "Used to indicate whether check will use http or https prototcol. Default is false which will use http."
}