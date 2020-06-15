This module creates a single cloudsql instance.  If you want to create multiple you should just call it multiple times with a different cloudsql_name variable.

It exposes the following variables:
   cloudsql_public_ip


####  Public Example
```
module "sql" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=ms-externaldnsport"

  providers = {
    google.target = google-beta
  }

  project                       = myproject
  cloudsql_name                 = myproject
  cloudsql_version              = "POSTGRES_11"
  cloudsql_authorized_networks  = var.broad_range_cidrs ## string list


}

```
####  Private Example
```
module "sql" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=ms-externaldnsport"

  providers = {
    google.target = google-beta
  }

  project                       = myproject
  cloudsql_name                 = myproject
  cloudsql_version              = "POSTGRES_11"
  cloudsql_authorized_networks  = var.broad_range_cidrs ## string list
  private_enable                = true
  private_network               = jade-network

}
```
