### HTTP Load Balancer

This module creates an HTTP load balancer, SSL policy, and health check.

### Providers

`google.target`: A google provider to use for all the resources

### Required variables

`project`: Google project in which to create resources

`ssl_policy_name`: A name for the SSL policy, must be unique within the google project

`load_balancer_name`: name for the LB

### Optional variables
`enable_flag`: turn on / off all resources except the SSL policy

`load_balancer_ssl_policy_create`: turn on / off the SSL policy

`load_balancer_ssl_certificates` : list of SSL certificate names (according to google) for the LB to use. Default `[]`

`load_balancer_ssl_policy_enable`: whether to apply the SSL policy to the LB. 0 or 1. Default 1

`load_balancer_instance_groups`: comma-separated list of instance-group names. Default empty

`load_balancer_health_check_path`: path to the health check. Defaults to `/status`

`load_balancer_health_check_interval`: seconds, default `5`

`load_balancer_health_check_timeout`: seconds, default `5`

`load_balancer_health_check_healthy_threshold`: number of healthy status checks before declaring a host healthy. Default 2

`load_balancer_health_check_unhealthy_threshold`: number of healthy status checks before declaring a host unhealthy. Default 2

``
### Outputs

`load_balancer_public_ip`: the public IP of the load balancer.
