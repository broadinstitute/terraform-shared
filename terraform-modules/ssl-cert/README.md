Creates a SSL certificate in a google project.

```
module "ssl-cert" {                                                       
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/ssl-cert?ref=ssl-cert-0.0.1"

  providers = {
    google      = google
  }
  ssl_certificate_name = "cloud-nat-name-region"
  ssl_certificate_key  = file("private.key")
  ssl_certificate_cert = file("server.crt")
}

```

## Required Providers

`google`: used for all resources 


## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ssl_certificate_name | The name of the cloud-nat service | string | ssl-certificat-<RANDOM-STRING> | no |
| ssl_certificate_key | private key for ssl cert | string | null | yes |
| ssl_certificate_cert | certificate for ssl cert | string | null | yes |

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| ssl_certificate_name | Name of the SSL cert created | string | 


