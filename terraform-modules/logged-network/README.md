Creates a network with subnets distributed like `auto_create_subnetworks` but with logging enabled.

```
module "network" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/logged-network?ref=rl-logged-network"
  google_project     = var.google_project                                
  network_name                    = "${var.owner}-terra-network"         
  providers = {                                                          
    "google-beta.target" = "google-beta"                                 
    "google.target" = "google"                                           
  }                                                                      
}                                                                        
```

## Required Providers

`google`: used to enable APIs in the network

`google-beta`: used to create the network (flow logging is a beta feature)

## Required Variables

`google_project`: Name of google project in which to create the network

## Optional Variables

`network_name`: Name for the network. Defaults to `app-services`

`subnet_cidrs`: Array of objects with `cidr` and `region` keys specifying the subnet layout. Defaults to the behavior of `auto_create_subnetworks`

`enable_flow_logs`: Whether to enable flow logs on the network. Defaults to true.

`aggregation_interval`: default `INTERVAL_10_MIN`

`flow_sampling`: default `0.5`

`metadata`: default `INCLUDE_ALL_METADATA`
