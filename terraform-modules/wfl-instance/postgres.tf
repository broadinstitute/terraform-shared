module "postgres" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=hf_postgres_update"

  providers = {
    google.target = google
  }

  cloudsql_name              = "${var.instance_id}-wfl"
  cloudsql_version           = "POSTGRES_11"
  cloudsql_tier              = "db-custom-1-3840"
  postgres_availability_type = "ZONAL"
  app_dbs = {
    default = {
      db       = "wfl"
      username = "wfl"
    }
  }
}
