
# module wide vars
# google project
variable "project" {}

# enable/disable var
variable "enable_flag" {
   default = "1"
}

variable "load_balancer_name" {
  default = "internal-load-balancer"
  description = "load balancer name"
}

# Load balancer vars

variable "load_balancer_instance_groups" {
  description = "Comma separated list of google self_links"
  default = ""
}

variable "load_balancer_ip_address" {
  description = "private ip address to use for load balancer"
  default = null
}

variable "load_balancer_timeout" {
  description = "in seconds how long to wait for backend response before considering backend failed"
  default = ""
}

variable "load_balancer_region" {
  description = "region name where load balancer is created"
  default = "us-central1"
}

variable "load_balancer_network_name" {
  description = "network name where load balancer is created"
  default = "app-services"
}

variable "load_balancer_subnetwork_name" {
  description = "subnetwork name where load balancer is created"
  default = ""
}

variable "load_balancer_protocol" {
  description = "Protocol for load balancer"
  default = "TCP"
}

variable "load_balancer_ports" {
  type = "list"
  description = "ports"
  default = [
    "80",
    "443" ]
}

# Health check vars

variable "load_balancer_health_check_path" {
  default = "/status"
  description = "path for health checks"
}

variable "load_balancer_health_check_port" {
  default = "443"
  description = "Health check port"
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

