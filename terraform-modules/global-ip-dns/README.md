Creates a global ip address and an associated DNS record

```
module "ip-dns" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/global-ip-dns?ref=global-ip-dns-0.0.1"

  providers = {
    google      = google
    google.dns_provider      = google.dnszone
  }
  auth_proxy_dns_name    = "dns-name"
  auth_proxy_dns_zone    = "dnz-zone"
}

```

## Required Providers

`google`: used for all resources 


## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| auth_proxy_dns_name | DNS name used for A record | string | auth-proxy | no |
| auth_proxy_dns_zone | DNS zone resource name | string | null | no |

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| public_ip | IP address allocated | string | 


