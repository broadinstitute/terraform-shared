# module wide vars
# google project
variable "project" {}

variable "ssl_policy_name" {
  description = "Name of your ssl policy. Must be specified to prevent collisions"
}

variable "min_tls_version" {
  description = "minimum tls version for SSL policy. Must be at least tls12-ssl-policy"
  default     = "TLS_1_2"
}

variable "load_balancer_ssl_policy_create" {
  default = 1
}

variable "load_balancer_ssl_policy_profile" {
  type = string
  description = "SSL Policy profile"
  default = "MODERN"
}

# enable/disable var
variable "enable_flag" {
  default = 1
}

variable "load_balancer_name" {
  description = "load balancer name"
}

# Load balancer vars

variable "load_balancer_ssl_certificates" {
  type        = list
  description = "SSL certs "
  default     = []
}

variable "load_balancer_ssl_policy_enable" {
  default = 1
}

variable "load_balancer_instance_groups" {
  description = "Comma separated list of google self_links"
  default     = ""
}

variable "load_balancer_rules" {
  description = "List of security policy rules to apply to LB"
  type = set(object({
      action=string,
      priority=string,
      ip_ranges=list(string),
      description=string
    })
  )
  default = []
}

# Health check vars

variable "load_balancer_health_check_path" {
  default     = "/status"
  description = "path for health checks"
}

variable "load_balancer_health_check_interval" {
  default     = "5"
  description = "Interval (secs) beteween checks"
}

variable "load_balancer_health_check_timeout" {
  default     = "5"
  description = "Timeout (secs) for health check"
}

variable "load_balancer_health_check_healthy_threshold" {
  default     = "2"
  description = "Threshold of successful checks to be healthy"
}

variable "load_balancer_health_check_unhealthy_threshold" {
  default     = "2"
  description = "Threshold of unsuccessful checks to be unhealthy"
}

