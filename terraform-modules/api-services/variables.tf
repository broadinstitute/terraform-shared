variable google_project {
  description = "Google project to enable services in. Defaults to provider project when left blank."
  type        = string
  default     = ""
}

variable destroy {
  description = "Whether to destroy on disable"
  type        = bool
  default     = false
}

variable enable_flag {
  description = "Enable/disable var"
  type = bool
  default = true
}

variable services {
  description = "Services to enable"
  type = list(string)
  default = [
    "appengineflex.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddebugger.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "dataflow.googleapis.com",
    "dataproc-control.googleapis.com",
    "dataproc.googleapis.com",
    "datastore.googleapis.com",
    "deploymentmanager.googleapis.com",
    "dns.googleapis.com",
    "file.googleapis.com",
    "genomics.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "redis.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "runtimeconfig.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "stackdriver.googleapis.com",
    "stackdriverprovisioning.googleapis.com",
    "staging-genomics.sandbox.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com"
  ]
}
