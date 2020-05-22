Creates a network with subnets allowing the caller to supply a map of subnets to create or accept the default of a subnet in every Google region similar to auto_create_subnetworks checked via the GUI.

Both the network and the subnet will be named the same.

By default flow logging and priviate IP google API access are disabled.

```
module "network" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/vpci-network?ref=vpc-network.1.0"
  network_name       = "network-name"         
}                                                                        
```

## Required Providers

This version of the module requires version 3.2 or higher of the Google provider

Module uses both of these two providers: google and google-beta.  If you do not pass them as arguments to module, the module relys on inheritence.  So your infrastructure does not set both(either at the root level or through passing them upon calling this module) this module will fail. 

You can pass in the providers by supplying the following code block when you call module

```
  providers = {                                                          
    "google-beta" = "google-beta.my-provider"
    "google"      = "google.my-provider"
  }                                                                      
```

The providers are used according to the following:

`google`: used to enable APIs in the network

`google-beta`: used to create the network (settings such as enabling flow logging requires beta provider)


## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| network_name | Name for the network. | string | app-services | no |
| aggregation_interval | Only used if vpc flow logging is enabled on subnet. Set globably for all subnets that have vpc flow logging enabled on. | string | INTERVAL_10_MIN | no |
| flow_sampling | Only used if vpc flow logging is enabled on subnet. Set globably for all subnets that have vpc flow logging enabled on. | string | 0.5 | no |
| metadata | Only used if vpc flow logging is enabled on subnet. Set globably for all subnets that have vpc flow logging enabled on. | string | INCLUDE_ALL_METADATA | no |
| subnets | Map of objects whos key is the Google Compute region (ie us-central1) with ALL of the following values: <ul><li>cidr: private IP block in CIDR format)</li><li>private_ip_access: Boolean determining if subnet is enabled for accessing Google APIs over private IPs</li><li>vpc_logging: Boolean determining if subnet has vpc_logging enabled</li></ul> | map | defaults to a map including all regions in the world. With vpc flow logs disabled and private_ip_access disabled. | no |


```
Ex:
  subnets = {
    "us-central1" = {
      cidr = "10.128.0.0/20"
      private_ip_access = true,
      vpc_logging = false,
    },
    "us-west1" = {
      cidr = "10.138.0.0/20"
      private_ip_access = false,
      vpc_logging = true,
    },
    "us-east1" = {
      cidr = "10.142.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
  }
```

If `subnets` variable is provided only the subnets specified in the `subnets` map will be created.

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| network | Network name created | string | 
| network_self_link | Google resource HTTP self link | string | 
| subnets_ips | map of CIDR ip range for each subnet created.  key is region of subnet (ie us-central1) | map | 
| subnets_self_links | map of Google resource HTTP self link for each subnet created.  key is region of subnet (ie us-central1) | map | 

## Notes
NOTE: until the terraform Google provider is updated to 3.X, you will see the following warning message
``` 
Warning: "enable_flow_logs": [DEPRECATED] This field is being removed in favor of log_config. If log_config is present, flow logs are enabled.
```

