Creates a network with subnets allowing the caller to supply a map of subnets to create or accept the default of a subnet in every Google region similar to auto_create_subnetworks checked via the GUI.

Both the network and the subnet will be named the same.

By default flow logging and priviate IP google API access are disabled.

```
module "network" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/vpci-network?ref=vpc-network.1.0"
  google_project     = "google-project-name"
  network_name       = "network-name"         
  providers = {                                                          
    "google-beta.target" = "google-beta"                                 
    "google.target"      = "google"                                           
  }                                                                      
}                                                                        
```

## Required Providers

`google`: used to enable APIs in the network

`google-beta`: used to create the network (settings such as enabling flow logging requires beta provider)

## Required Variables

`google_project`: Name of google project in which to create the network

## Optional Variables

`network_name`: Name for the network. Defaults to `app-services`

NOTE: The following 3 variables are used as global defaults for any subnet that will have flow logs enabled on.
 * `aggregation_interval`: default `INTERVAL_10_MIN`
 * `flow_sampling`: default `0.5`
 * `metadata`: default `INCLUDE_ALL_METADATA`

`subnets`: Map of objects whose key is the Google Compute region (ex: us-central1) with all the following values:
 * `cidr`: private IP block in CIDR format) 
 * `private_ip_access`: Boolean determining if subnet is enabled for accessing Google APIs over private IPs 
 * `vpc_logging`: Boolean determining if subnet has vpc_logging enabled

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

Only the subnets specified in the `subnets` map will be created.

NOTE: until the terraform Google provider is updated to 3.X, you will see the following warngin message
``` 
Warning: "enable_flow_logs": [DEPRECATED] This field is being removed in favor of log_config. If log_config is present, flow logs are enabled.
```

