
# module wide vars
# google project
variable "project" {}

# enable/disable var
variable "enable_flag" {
   default = "1"
}

variable "load_balancer_name" {
  default = "load-balancer"
  description = "load balancer name"
}

# Load balancer vars

variable "load_balancer_ssl_certificates" {
  type = "list"
  description = "SSL certs "
  default = [ ]
}

variable "load_balancer_ssl_policy_enable" {
  default = "1"
}

variable "load_balancer_ssl_policy" {
  default = "tls12-ssl-policy"
}

variable "load_balancer_instance_groups" {
  description = "Comma separated list of google self_links"
  default = ""
}

# Health check vars

variable "load_balancer_health_check_url" {
  default = "/status"
  description = "URL for health checks"
}

variable "load_balancer_health_check_interval" {
  default = "5"
  description = "Interval (secs) beteween checks"
}

variable "load_balancer_health_check_timeout" {
  default = "5"
  description = "Timeout (secs) for health check"
}

variable "load_balancer_health_check_healthy_threshold" {
  default = "2"
  description = "Threshold of successful checks to be healthy"
}

variable "load_balancer_health_check_unhealthy_threshold" {
  default = "2"
  description = "Threshold of unsuccessful checks to be unhealthy"
}

