#
# Google
#

variable "google_project" {
  type        = string
  description = "ID of the GCP project to create resources in. Defaults to provider project."
  default     = null
}

variable "google_region" {
  type        = string
  description = "GCP region to create resources in. Defaults to provider region."
  default     = null
}


#
# Service Account
#

variable "service_account_create" {
  type        = bool
  description = <<-EOT
    Whether this module should create `{service_account_id}` in `{function_project}`
    or assume it already exists.
  EOT
  default     = true
}

variable "service_account_id" {
  type        = string
  description = <<-EOT
    The ID of the service account to use, by default calculated to `{function_name}-sa`.
    If `{service_account_create}` is false, can reference cross-project by providing full email.
  EOT
  default     = ""
}

variable "service_account_description" {
  type        = string
  description = <<-EOT
    If `{service_account_create}` is true, the description of the service account,
    by default calculated to `Service Account for {function_name} Cloud Function`.
  EOT
  default     = null
}

locals {
  service_account_id_to_use = var.service_account_id == "" ? "${var.function_name}-sa" : var.service_account_id
  service_account_description_to_use = (
    var.service_account_description == null ?
    "Service Account for ${var.function_name} Cloud Function" :
    var.service_account_description
  )
}

#
# Cloud Function
#

# Required

variable "function_name" {
  type        = string
  description = "The name of the cloud function."
}

variable "function_runtime" {
  type        = string
  description = <<-EOT
    The ID of the language runtime for the function, from
    https://cloud.google.com/functions/docs/concepts/exec#runtimes.
  EOT
}

variable "function_entry_point" {
  type        = string
  description = "The exact name of the function/class in the code to run."
}

# Trigger

variable "function_event_trigger" {
  type = object({
    event_type = string
    resource   = string
    retry      = bool
  })
  description = <<-EOT
    Trigger this function upon an event in another service, like Cloud Pub/Sub.

    Exactly one of either this field or `function_trigger_http` must be provided.

    `event_type` is one of https://cloud.google.com/functions/docs/calling/#event_triggers.
    `resource` is a name or partial URI (e.g. "projects/my-project/topics/my-topic").
    `retry` indicates whether the function should be retried upon failure.
  EOT
  default     = null
}

variable "function_trigger_http" {
  type        = bool
  description = <<-EOT
    Trigger this function upon HTTP requests (POST, PUT, GET, DELETE, and OPTIONS).
    Exactly one of either this field or `function_event_trigger` must be provided.

    The URL of the cloud function will be the following:
    `https://{google_region}-{google_project}.cloudfunctions.net/{function_name}`.
  EOT
  default     = false
}

variable "function_invokers" {
  type        = set(string)
  description = <<-EOT
    A list of additional identities permitted to use this specific cloud function.
    Particularly useful for allowing "allUsers" to invoke an HTTP-triggered function.
    Inherited permissions mean that adding yourself or your team is usually not necessary.

    Possible identities listed here:
    https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam#member/members

    Each identity will be granted "roles/cloudfunctions.invoker" on the cloud function resource.
  EOT
  default     = []
}

# Source

variable "function_source_archive" {
  type = object({
    archive_bucket = string
    archive_object = string
  })
  description = <<-EOT
    A GCS bucket/object pointing to a ZIP file containing the source code for the cloud function.
    The source code must be at the root of the ZIP file, not inside an interior folder.

    Exactly one of either this field or `function_source_repository` must be provided.

    See https://cloud.google.com/functions/docs/writing#structuring_source_code
    for more information.
  EOT
  default     = null
}

variable "function_source_repository" {
  type = object({
    repository_google_project = string
    repository_name           = string
    repository_tag            = string
    repository_path           = string
  })
  description = <<-EOT
    A Cloud Source Repository reference containing the source code for the cloud function.
    This can be an automatically-syncing mirror of a GitHub repo, just ping DevOps for help.

    Exactly one of either this field or `function_source_archive` must be provided.

    `repository_google_project` is the ID of the project where the repository resides.
    `repository_name` is the name of the repository (if a mirror, usually `github_broadinstitute_...`).
    `repository_tag` is the tag to check out (if a mirror, tags are synced from GitHub too).
    `repository_path` is the relative path to the code itself (set to empty for repository root).

    See https://cloud.google.com/functions/docs/writing#structuring_source_code
    for more information.
  EOT
  default     = null
}

# Secrets and environment

variable "function_vault_secrets" {
  type = map(object({
    vault_secret_path       = string
    vault_secret_json_key   = string
    env_var_for_secret_name = string
  }))
  description = <<-EOT
    Secrets from Vault to make available to the cloud function via Secret Manager.
    For each `{vault_secret_json_key}` field extracted from Vault at `{vault_secret_path}`,
    the function will have an environment variable `{env_var_for_secret_name}` containing the 
    full name of the Secret Manager "version" containing the secret value.

    The cloud function's service account will be able to access these values--you may use
    https://cloud.google.com/secret-manager/docs/reference/libraries without setting up
    authentication. See README.md for more information.
  EOT
  default     = {}
}

variable "function_insecure_environment_variables" {
  type        = map(any)
  description = <<-EOT
    Mapping of environment variables to be entered into the function's environment. 
    This is PLAIN TEXT and will be revealed during Terraform Plan: it is not suitable 
    for secrets, see function_vault_secrets for the proper method.
  EOT
  default     = {}
}

variable "function_insecure_build_environment_variables" {
  type        = map(any)
  description = <<-EOT
    Mapping of environment variables to be entered into the build-time environment.
    This is PLAIN TEXT and will be revealed during Terraform Plan: it is not suitable 
    for secrets.
  EOT
  default     = {}
}

# Optional

variable "function_description" {
  type        = string
  description = "Optional description of the function."
  default     = null
}

variable "function_available_memory_mb" {
  type        = number
  description = "Optional memory (in MB) available to the function, defaults to 256."
  default     = null
}

variable "function_timeout" {
  type        = number
  description = "Optional timeout (in seconds) for the function, defaults to 60."
  default     = null
}

variable "function_ingress_settings" {
  type        = string
  description = <<-EOT
    Optional value to control what traffic may reach the function:
    `ALLOW_ALL`, `ALLOW_INTERNAL_ONLY`, or `ALLOW_INTERNAL_AND_GCLB` (Cloud Load Balancing).
    The default behavior is `ALLOW_ALL`.
    
    More information is available at 
    https://cloud.google.com/functions/docs/networking/network-settings.
  EOT
  default     = null
}

variable "function_labels" {
  type        = map(any)
  description = <<-EOT
    An optional set of key/value label pairs to assign to the function resource.

    Label keys must follow the requirements at
    https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements.
  EOT
  default     = null
}

variable "function_vpc_connector" {
  type        = string
  description = <<-EOT
    Optional VPC Network Connector for the cloud function to be able to connect to.
    Format is `projects/*/locations/*/connectors/*` (fully qualified URI).
  EOT
  default     = null
}

variable "function_vpc_connector_egress_settings" {
  type        = string
  description = <<-EOT
    Optional egress settings for a VPC Network Connector, controlling what traffic
    is diverted through it. May be either `ALL_TRAFFIC` or `PRIVATE_RANGES_ONLY`, 
    defaults to `PRIVATE_RANGES_ONLY`.
  EOT 
  default     = null
}

variable "function_max_instances" {
  type        = number
  description = "Optional limit on the number of function instances that can exist at once."
  default     = null
}

#
# Monitoring
#

variable "monitoring_success_statuses" {
  type = set(string)
  description = <<-EOT
    Set of function execution statuses that should be considered successful, and should not alert.

    For HTTP functions especially, it might be desirable to have 'error' executions
    not alert, because 400-series responses are considered errors by GCP.

    Possible execution statuses:
    'ok', 'timeout', 'error', 'crash', 'out of memory', 'out of quota', 'load error', 'load timeout',
    'connection error', 'invalid header', 'request too large', 'system error', 'response error',
    'invalid message'
  EOT
  default = [ "ok" ]
}

variable "monitoring_channel_names" {
  type        = set(string)
  description = "Optional set of already-configured Cloud Monitoring channel display names to notify upon function crashes."
  default     = []
}

variable "monitoring_failure_trigger_count" {
  type        = number
  description = "The number of failed executions in `{monitoring_failure_trigger_period}` that triggers an alert."
  default     = 1
}

variable "monitoring_failure_trigger_period" {
  type        = string
  description = "The period of time (in seconds) to count failures in to compare with `{monitoring_failure_trigger_count}`."
  default     = "60s"
}

locals {
  monitoring_failure_statuses_filter = join(" && ", [for s in var.monitoring_success_statuses: "metric.status != '${s}'"])
}
