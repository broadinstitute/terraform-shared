 # cloud-function

A convenience module helping securely deploy Google Cloud Functions.

It has core behavior similar to the normal [cloud function resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function),
but it has several other features included.

> This documentation is generated via `terraform-docs markdown .` (requires 0.14.0 or higher).

## Features

Click for details:

<details> 
<summary>
Can create a named service account to avoid the potentially-insecure App Engine default service account
</summary>

- By default, [service\_account\_create](#input\_service\_account\_create) is `true` and [service\_account\_id](#input\_service\_account\_id) will be set to `{function_name}-sa`
- [service\_account\_create](#input\_service\_account\_create) can be set to `false` and [service\_account\_id](#input\_service\_account\_id) can be set to an existing service account--even one in another project, referenced by full email

</details>

<details>
<summary>
Can modify permissions to allow broader sets of users (even unauthenticated ones) to trigger the function
</summary>

- See the [function\_invokers](#input\_function\_invokers) field
- This is particularly useful for resolving [403 forbidden errors](https://cloud.google.com/functions/docs/troubleshooting#private) upon trying to call the function

</details>

<details>
<summary>
Can notify Slack channels if the function fails
</summary>

- Cloud Monitoring notification channel must already be configured in the UI, within the [google\_project](#input\_google\_project) you plan to use--[configuration page here](https://console.cloud.google.com/monitoring/alerting/notifications)
- More than just Slack channels can be set--pass monitoring channel "display names" to [monitoring\_channel\_names](#input\_monitoring\_channel\_names)
- Adjust what is considered a failure via [monitoring\_success\_statuses](#input\_monitoring\_success\_statuses)--for HTTP functions, you may not want to alert on 'error' executions, since those include 400-series responses to clients

</details>

<details>
<summary>
Can sync secrets from Vault to Google Secret Manager, allowing the cloud function's service account to read them without insecure use of the environment
</summary>

- See the [function\_vault\_secrets](#input\_function\_vault\_secrets) field--specify the path to the Vault secret, the particular field within the Vault secret, and the environment variable to contain the Secret Manager secret name
- Rather than setting environment variables containing Vault secret values, this module sets them containing full names of [Secret Manager secret "versions"](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#access), in the form `projects/*/secrets/*/versions/*`
- The module configures Secret Manager permissions such that, from within the cloud function, Secret Manager client libraries can access the secret values without configuration

Example for Python ([client library here](https://cloud.google.com/secret-manager/docs/reference/libraries#client-libraries-install-python)):
```python
from google.cloud import secretmanager

# One "client" can read multiple secrets
secret_manager_client = secretmanager.SecretManagerServiceClient()

# This Terraform module will maintain the MY_SECRET_NAME environment variable
my_secret_value = secret_manager_client\
  .access_secret_version(name=os.environ['MY_SECRET_NAME'])\
  .payload.data.decode('UTF-8')
```

Example for Java ([client library here](https://cloud.google.com/secret-manager/docs/reference/libraries#client-libraries-install-java)):
```java
import com.google.cloud.secretmanager.v1.SecretManagerServiceClient;

import java.io.IOException;

class Example {
    public static void main(String[] args) throws IOException {
        // One "client" can read multiple secrets
        try (SecretManagerServiceClient client = SecretManagerServiceClient.create()) {
            // This Terraform module will maintain the MY_SECRET_NAME environment variable
            String mySecretValue = client
                    .accessSecretVersion(System.getenv("MY_SECRET_NAME"))
                    .getPayload().getData().toStringUtf8();
        }
    }
}
```

Documentation for other languages is [available here](https://cloud.google.com/secret-manager/docs/reference/libraries#using_the_client_library).

</details>

[//]: # (BEGIN_TF_DOCS)
## Example

<details>
<summary>
Click to expand
</summary>

```hcl
module "test_cloud_function" {
  # Change the trailing ref to adjust version
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloud-function?ref=cloud-function-1.0.0"

  providers = {
    google = google
    vault  = vault
  }

  function_name        = "my-function"
  function_runtime     = "python39"
  function_entry_point = "my_python_function"

  # Supply function_event_trigger or function_trigger_http
  function_event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource   = "projects/broad-dsde-dev/topics/my-topic"
    retry      = true
  }

  # Supply function_source_archive or function_source_repository
  function_source_archive = {
    archive_bucket = "gs://my-bucket"
    archive_object = "my-code.zip"
  }

  # Optionally, specify secrets to be synced from Vault
  function_vault_secrets = {
    "my_api_key" = {
      vault_secret_path       = "secret/path/in/vault"
      vault_secret_json_key   = "my-api-key"
      env_var_for_secret_name = "MY_API_KEY_NAME"
    }
  }

  # Optionally, specify Cloud Monitoring Channels to be notified on failure
  monitoring_channel_names = [
    "#my-team-channel"
  ]
}

```

</details>

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.12.19)

- <a name="requirement_google"></a> [google](#requirement\_google) (>= 3.65.0)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (>= 2.8.0)

## Required Inputs

The following input variables are required:

### <a name="input_function_name"></a> [function\_name](#input\_function\_name)

Description: The name of the cloud function.

Type: `string`

### <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime)

Description: The ID of the language runtime for the function, from  
https://cloud.google.com/functions/docs/concepts/exec#runtimes.

Type: `string`

### <a name="input_function_entry_point"></a> [function\_entry\_point](#input\_function\_entry\_point)

Description: The exact name of the function/class in the code to run.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_google_project"></a> [google\_project](#input\_google\_project)

Description: ID of the GCP project to create resources in. Defaults to provider project.

Type: `string`

Default: `null`

### <a name="input_google_region"></a> [google\_region](#input\_google\_region)

Description: GCP region to create resources in. Defaults to provider region.

Type: `string`

Default: `null`

### <a name="input_service_account_create"></a> [service\_account\_create](#input\_service\_account\_create)

Description: Whether this module should create `{service_account_id}` in `{function_project}`  
or assume it already exists.

Type: `bool`

Default: `true`

### <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id)

Description: The ID of the service account to use, by default calculated to `{function_name}-sa`.  
If `{service_account_create}` is false, can reference cross-project by providing full email.

Type: `string`

Default: `""`

### <a name="input_service_account_description"></a> [service\_account\_description](#input\_service\_account\_description)

Description: If `{service_account_create}` is true, the description of the service account,  
by default calculated to `Service Account for {function_name} Cloud Function`.

Type: `string`

Default: `null`

### <a name="input_function_event_trigger"></a> [function\_event\_trigger](#input\_function\_event\_trigger)

Description: Trigger this function upon an event in another service, like Cloud Pub/Sub.

Exactly one of either this field or `function_trigger_http` must be provided.

`event_type` is one of https://cloud.google.com/functions/docs/calling/#event_triggers.
`resource` is a name or partial URI (e.g. "projects/my-project/topics/my-topic").
`retry` indicates whether the function should be retried upon failure.

Type:

```hcl
object({
    event_type = string
    resource   = string
    retry      = bool
  })
```

Default: `null`

### <a name="input_function_trigger_http"></a> [function\_trigger\_http](#input\_function\_trigger\_http)

Description: Trigger this function upon HTTP requests (POST, PUT, GET, DELETE, and OPTIONS).  
Exactly one of either this field or `function_event_trigger` must be provided.

The URL of the cloud function will be the following:
`https://{google_region}-{google_project}.cloudfunctions.net/{function_name}`.

Type: `bool`

Default: `false`

### <a name="input_function_invokers"></a> [function\_invokers](#input\_function\_invokers)

Description: A list of additional identities permitted to use this specific cloud function.  
Particularly useful for allowing "allUsers" to invoke an HTTP-triggered function.  
Inherited permissions mean that adding yourself or your team is usually not necessary.

Possible identities listed here:  
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam#member/members

Each identity will be granted "roles/cloudfunctions.invoker" on the cloud function resource.

Type: `set(string)`

Default: `[]`

### <a name="input_function_source_archive"></a> [function\_source\_archive](#input\_function\_source\_archive)

Description: A GCS bucket/object pointing to a ZIP file containing the source code for the cloud function.  
The source code must be at the root of the ZIP file, not inside an interior folder.

Exactly one of either this field or `function_source_repository` must be provided.

See https://cloud.google.com/functions/docs/writing#structuring_source_code  
for more information.

Type:

```hcl
object({
    archive_bucket = string
    archive_object = string
  })
```

Default: `null`

### <a name="input_function_source_repository"></a> [function\_source\_repository](#input\_function\_source\_repository)

Description: A Cloud Source Repository reference containing the source code for the cloud function.  
This can be an automatically-syncing mirror of a GitHub repo, just ping DevOps for help.

Exactly one of either this field or `function_source_archive` must be provided.

`repository_google_project` is the ID of the project where the repository resides.
`repository_name` is the name of the repository (if a mirror, usually `github_broadinstitute_...`).
`repository_tag` is the tag to check out (if a mirror, tags are synced from GitHub too).
`repository_path` is the relative path to the code itself (set to empty for repository root).

See https://cloud.google.com/functions/docs/writing#structuring_source_code  
for more information.

Type:

```hcl
object({
    repository_google_project = string
    repository_name           = string
    repository_tag            = string
    repository_path           = string
  })
```

Default: `null`

### <a name="input_function_vault_secrets"></a> [function\_vault\_secrets](#input\_function\_vault\_secrets)

Description: Secrets from Vault to make available to the cloud function via Secret Manager.  
For each `{vault_secret_json_key}` field extracted from Vault at `{vault_secret_path}`,  
the function will have an environment variable `{env_var_for_secret_name}` containing the   
full name of the Secret Manager "version" containing the secret value.

The cloud function's service account will be able to access these values--you may use  
https://cloud.google.com/secret-manager/docs/reference/libraries without setting up  
authentication. See README.md for more information.

Type:

```hcl
map(object({
    vault_secret_path       = string
    vault_secret_json_key   = string
    env_var_for_secret_name = string
  }))
```

Default: `{}`

### <a name="input_function_insecure_environment_variables"></a> [function\_insecure\_environment\_variables](#input\_function\_insecure\_environment\_variables)

Description: Mapping of environment variables to be entered into the function's environment.   
This is PLAIN TEXT and will be revealed during Terraform Plan: it is not suitable   
for secrets, see function\_vault\_secrets for the proper method.

Type: `map(any)`

Default: `{}`

### <a name="input_function_insecure_build_environment_variables"></a> [function\_insecure\_build\_environment\_variables](#input\_function\_insecure\_build\_environment\_variables)

Description: Mapping of environment variables to be entered into the build-time environment.  
This is PLAIN TEXT and will be revealed during Terraform Plan: it is not suitable   
for secrets.

Type: `map(any)`

Default: `{}`

### <a name="input_function_description"></a> [function\_description](#input\_function\_description)

Description: Optional description of the function.

Type: `string`

Default: `null`

### <a name="input_function_available_memory_mb"></a> [function\_available\_memory\_mb](#input\_function\_available\_memory\_mb)

Description: Optional memory (in MB) available to the function, defaults to 256.

Type: `number`

Default: `null`

### <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout)

Description: Optional timeout (in seconds) for the function, defaults to 60.

Type: `number`

Default: `null`

### <a name="input_function_ingress_settings"></a> [function\_ingress\_settings](#input\_function\_ingress\_settings)

Description: Optional value to control what traffic may reach the function:
`ALLOW_ALL`, `ALLOW_INTERNAL_ONLY`, or `ALLOW_INTERNAL_AND_GCLB` (Cloud Load Balancing).  
The default behavior is `ALLOW_ALL`.  

More information is available at   
https://cloud.google.com/functions/docs/networking/network-settings.

Type: `string`

Default: `null`

### <a name="input_function_labels"></a> [function\_labels](#input\_function\_labels)

Description: An optional set of key/value label pairs to assign to the function resource.

Label keys must follow the requirements at  
https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements.

Type: `map(any)`

Default: `null`

### <a name="input_function_vpc_connector"></a> [function\_vpc\_connector](#input\_function\_vpc\_connector)

Description: Optional VPC Network Connector for the cloud function to be able to connect to.  
Format is `projects/*/locations/*/connectors/*` (fully qualified URI).

Type: `string`

Default: `null`

### <a name="input_function_vpc_connector_egress_settings"></a> [function\_vpc\_connector\_egress\_settings](#input\_function\_vpc\_connector\_egress\_settings)

Description: Optional egress settings for a VPC Network Connector, controlling what traffic  
is diverted through it. May be either `ALL_TRAFFIC` or `PRIVATE_RANGES_ONLY`,   
defaults to `PRIVATE_RANGES_ONLY`.

Type: `string`

Default: `null`

### <a name="input_function_max_instances"></a> [function\_max\_instances](#input\_function\_max\_instances)

Description: Optional limit on the number of function instances that can exist at once.

Type: `number`

Default: `null`

### <a name="input_monitoring_success_statuses"></a> [monitoring\_success\_statuses](#input\_monitoring\_success\_statuses)

Description: Set of function execution statuses that should be considered successful, and should not alert.

For HTTP functions especially, it might be desirable to have 'error' executions  
not alert, because 400-series responses are considered errors by GCP.

Possible execution statuses:
'ok', 'timeout', 'error', 'crash', 'out of memory', 'out of quota', 'load error', 'load timeout',
'connection error', 'invalid header', 'request too large', 'system error', 'response error',
'invalid message'

Type: `set(string)`

Default:

```json
[
  "ok"
]
```

### <a name="input_monitoring_channel_names"></a> [monitoring\_channel\_names](#input\_monitoring\_channel\_names)

Description: Optional set of already-configured Cloud Monitoring channel display names to notify upon function crashes.

Type: `set(string)`

Default: `[]`

### <a name="input_monitoring_failure_trigger_count"></a> [monitoring\_failure\_trigger\_count](#input\_monitoring\_failure\_trigger\_count)

Description: The number of failed executions in `{monitoring_failure_trigger_period}` that triggers an alert.

Type: `number`

Default: `1`

### <a name="input_monitoring_failure_trigger_period"></a> [monitoring\_failure\_trigger\_period](#input\_monitoring\_failure\_trigger\_period)

Description: The period of time (in seconds) to count failures in to compare with `{monitoring_failure_trigger_count}`.

Type: `string`

Default: `"60s"`

## Outputs

The following outputs are exported:

### <a name="output_function_service_account_email"></a> [function\_service\_account\_email](#output\_function\_service\_account\_email)

Description: Email of the service account used for the cloud function

### <a name="output_function_https_trigger_url"></a> [function\_https\_trigger\_url](#output\_function\_https\_trigger\_url)

Description: When `function_trigger_http` is true, this is the URL of the cloud function.

The URL of the cloud function will be the following:
`https://{google_region}-{google_project}.cloudfunctions.net/{function_name}`.

[//]: # (END_TF_DOCS)
