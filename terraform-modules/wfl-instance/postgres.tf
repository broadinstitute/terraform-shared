module "postgres" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=cloudsql-postgres-1.2.2"

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
  cloudsql_instance_labels = local.labels

}
