Creates a cloud-net service in a google project on a specific network for a specific region.  Hence if Cloud-NAT services are needed for multiple regions within a specific network, multiple instances of this module will need to be used.

NOTE: due to leveraging the capability to place labels on ip address, this requires the google-beta provider.

```
module "cloud-nat" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloud-nat?ref=cloud-nat-0.0.1"

  providers = {
    google      = google
    google-beta = google-beta
  }
  cloud_nat_name    = "cloud-nat-name-region"
  cloud_nat_region  = "us-central1"
  cloud_nat_num_ips = "1"
  cloud_nat_network    = "app-services"
  cloud_nat_subnetwork = "app-services"
}

```

## Required Providers

`google`: used for all resources other than ip addressesvpc-network

`google-beta`: used for creating the public ip addresses for the cloud-nat service.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloud_nat_name | The name of the cloud-nat service | string | cloud-nat-<RANDOM-STRING> | no |
| cloud_nat_region | Google region to create NAT service in | string | us-central1 | yes |
| cloud_nat_num_ips | The number of public IPs that will be used by cloud NAT | number | 1 | no |
| cloud_nat_network | The network name to create cloud NAT service for | string | app-services | no |
| cloud_nat_subnetwork | The subnet name to create cloud NAT service for | string | app-services | no |

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| cloud_nat_ips | The list of ip addresses in use by cloud nat service | list | 


