Creates a firewall rule in a google project

NOTE: This module requires Terraform 0.12.20 or higher and enables an expiremental option (variable_validation).  This is necessary in order to prevent calling the module with an emnpty list of source_ranges which will create a firewall rule that has no source_ranges - which is impllied to be 0.0.0.0 which is all ips.

```
module "firewall-rule" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/firewall-rule?ref=firewall-rule-0.0.1"

  providers = {
    google      = google
  }

  firewall_rule_name          = "firewall-rule-name"
  firewall_rule_network       = "app-services"
  firewall_rule_source_ranges = [ "ip-address-1", "ip-address-2" ]
  firewall_rule_ports         = ["80", "443"]
  firewall_rule_target_tags   = ["target-tag"]
  firewall_rule_logging       = true
}

```

NOTE: module will fail if name specified is already in use in the google project

## Required Providers

`google`: used for all resources other than ip addressesvpc-network


## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| firewall_rule_name | The name of the firewall rule to create | string | firewall-rule-<RANDOM-HEXSTRING> | no |
| firewall_rule_network | The network name to create firewall rule against | string | app-services | no |
| firewall_rule_source_ranges | list of source IPs for firewall rule | list | null | yes |
| firewall_rule_ports | list of ports to permit | list | null | no |
| firewall_rule_target_tags | list of network tags to apply firewall to | list | null | no |
| firewall_rule_logging | Boolean flag to turn on/off stackdriver logging for firewall rule | bool | false | no |

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| firewall_rule | firewall rule created | google resource | 


