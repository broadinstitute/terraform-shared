This module creates INTERNAL network load balancer

The following are the module defaults:

`load_balancer_name`: internal-load-balancer

`load_balancer_network_name`: us-central1

`load_balancer_protocol`: TCP

`load_balancer_ports`: list containing 80 and 443

`load_balancer_health_check_path`: /status

`load_balancer_health_check_port`: 443

`load_balancer_health_check_interval`: 5 (secs)

`load_balancer_health_check_timeout`: 5 (secs)

`load_balancer_health_check_healthy_threshold`: 2

`load_balancer_health_check_unhealthy_threshold`: 2

The following variables have a null string as default:

`load_balancer_instance_groups`: This is a list of the fully qualified URL pointing to the instance groups.

`load_balancer_ip_address`: private IP address to use for the load balancer if it is left unspecified (which is the recommended) Google will select an appropriate one in the subnet that it is created in.  If you specify an ip address it is up to you to ensure it is available and in the correct region.

If the variable `load_balancer_subnetwork_name` is not specified it is defaulted to the same as the network name.  This is important since for networks that are auto-sbubnetted - the subnetname and network name are true.  For non auto-subnetted networks, you need to specify both network and subnet names.

The OUTPUTS for this module are:
load_balancer_ip:  The private ip address of the load balancer than is created

NOTES:
  THis module does not validate that the instance groups exist or that they were created in the correct region.  Instance groups must be created in the same region as the load balancer is being created in.


