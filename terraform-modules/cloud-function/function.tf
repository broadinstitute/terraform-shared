resource "google_service_account" "create_function_sa" {
  count       = var.service_account_create ? 1 : 0
  project     = var.google_project
  description = local.service_account_description_to_use
  account_id  = local.service_account_id_to_use
}

data "google_service_account" "get_function_sa" {
  count      = var.service_account_create ? 0 : 1
  account_id = local.service_account_id_to_use
}

resource "google_cloudfunctions_function" "function" {
  # Google
  project = var.google_project
  region  = var.google_region
  service_account_email = (
    var.service_account_create ?
    google_service_account.create_function_sa[0].email :
    data.google_service_account.get_function_sa[0].email
  )

  # Required
  name        = var.function_name
  runtime     = var.function_runtime
  entry_point = var.function_entry_point

  # Trigger
  dynamic "event_trigger" {
    for_each = var.function_event_trigger != null ? [var.function_event_trigger] : []
    content {
      event_type = event_trigger.value["event_type"]
      resource   = event_trigger.value["resource"]
      failure_policy {
        retry = event_trigger.value["retry"]
      }
    }
  }
  trigger_http = var.function_trigger_http ? true : null

  # Source
  source_archive_bucket = var.function_source_archive != null ? var.function_source_archive["archive_bucket"] : null
  source_archive_object = var.function_source_archive != null ? var.function_source_archive["archive_object"] : null
  dynamic "source_repository" {
    for_each = var.function_source_repository != null ? [var.function_source_repository] : []
    content {
      url = "https://source.developers.google.com/projects/${
        source_repository.value["repository_google_project"]
        }/repos/${
        source_repository.value["repository_name"]
        }/fixed-aliases/${
        source_repository.value["repository_tag"]
        }/paths/${
        source_repository.value["repository_path"]
      }"
    }
  }

  # Secrets and environment
  environment_variables = merge(
    {
      for k, v in var.function_vault_secrets : v["env_var_for_secret_name"] => google_secret_manager_secret_version.secret_manager_secret_version[k].id
    },
    var.function_insecure_environment_variables
  )
  build_environment_variables = var.function_insecure_build_environment_variables

  # Optional
  description                   = var.function_description
  available_memory_mb           = var.function_available_memory_mb
  timeout                       = var.function_timeout
  ingress_settings              = var.function_ingress_settings
  labels                        = var.function_labels
  vpc_connector                 = var.function_vpc_connector
  vpc_connector_egress_settings = var.function_vpc_connector_egress_settings
  max_instances                 = var.function_max_instances
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  for_each       = var.function_invokers
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = each.key
}
