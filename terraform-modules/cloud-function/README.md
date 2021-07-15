 # cloud-function

A convenience module helping securely deploy Google Cloud Functions.

It has core behavior similar to the normal [cloud function resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function),
but it has several other features included.

This documentation is generated via `terraform-docs markdown .`

## Features

<details> 
<summary>
Can create a named service account to avoid the potentially-insecure App Engine default service account
</summary>

- By default, [service\_account\_create](#input\_service\_account\_create) is `true` and [service\_account\_id](#input\_service\_account\_id) will be set to `{function_name}-sa`
- [service\_account\_create](#input\_service\_account\_create) can be set to `false` and [service\_account\_id](#input\_service\_account\_id) can be set to an existing service account--even one in another project, referenced by full email

</details>

<details>
<summary>Can modify permissions to allow broader sets of users (even unauthenticated ones) to trigger the function</summary>

- See the [function\_invokers](#input\_function\_invokers) field
- This is particularly useful for resolving [403 forbidden errors](https://cloud.google.com/functions/docs/troubleshooting#private) upon trying to call the function

</details>

<details>
<summary>Can notify Slack channels if the function crashed or exits with an error</summary>

- Cloud Monitoring notification channel must already be configured in the UI, within the [google\_project](#input\_google\_project) you plan to use--[configuration page here](https://console.cloud.google.com/monitoring/alerting/notifications)
- More than just Slack channels can be set--pass monitoring channel "display names" to [monitoring\_channel\_names](#input\_monitoring\_channel\_names)

</details>

<details>
<summary>Can sync secrets from Vault to Google Secret Manager, allowing the cloud function's service account to read them without insecure use of the environment</summary>

- See the function\_vault\_secrets](#input\_function\_vault\_secrets) field--specify the path to the Vault secret, the particular field within the Vault secret, and the environment variable to contain the Secret Manager secret name
- Rather than setting environment variables containing Vault secret values, this module sets them containing full names of [Secret Manager secret "versions"](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#access), in the form `projects/*/secrets/*/versions/*`
- The module configures Secret Manager permissions such that, from within the cloud function, Secret Manager client libraries can access the secret values without configuration

Example for Python ([client library here](https://cloud.google.com/secret-manager/docs/reference/libraries#client-libraries-install-python)):
```python
from google.cloud import secretmanager

# One "client" can read multiple secrets
secret_manager_client = secretmanager.SecretManagerServiceClient()

# This Terraform module will maintain the MY_SECRET_ID environment variable
my_secret_value = secret_manager_client\
  .access_secret_version(name=os.environ['MY_SECRET_ID'])\
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
            // This Terraform module will maintain the MY_SECRET_ID environment variable
            String mySecretValue = client
                    .accessSecretVersion(System.getenv("MY_SECRET_ID"))
                    .getPayload().getData().toStringUtf8();
        }
    }
}
```

</details>

[//]: # (BEGIN_TF_DOCS)

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.65.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.8.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_google_project"></a> [google\_project](#input\_google\_project) | ID of the GCP project to create resources in. Defaults to provider project. | `string` | `null` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | GCP region to create resources in. Defaults to provider region. | `string` | `null` | no |
| <a name="input_service_account_create"></a> [service\_account\_create](#input\_service\_account\_create) | Whether this module should create `{service_account_id}` in `{function_project}`<br>or assume it already exists. | `bool` | `true` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The ID of the service account to use, by default calculated to `{function_name}-sa`.<br>If `{service_account_create}` is false, can reference cross-project by providing full email. | `string` | `""` | no |
| <a name="input_service_account_description"></a> [service\_account\_description](#input\_service\_account\_description) | If `{service_account_create}` is true, the description of the service account,<br>by default calculated to `Service Account for {function_name} Cloud Function`. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the cloud function. | `string` | n/a | yes |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | The ID of the language runtime for the function, from<br>https://cloud.google.com/functions/docs/concepts/exec#runtimes. | `string` | n/a | yes |
| <a name="input_function_entry_point"></a> [function\_entry\_point](#input\_function\_entry\_point) | The exact name of the function/class in the code to run. Defaults to `{function_name}`. | `string` | n/a | yes |
| <a name="input_function_event_trigger"></a> [function\_event\_trigger](#input\_function\_event\_trigger) | Trigger this function upon an event in another service, like Cloud Pub/Sub.<br><br>Exactly one of either this field or `function_trigger_http` must be provided.<br><br>`event_type` is one of https://cloud.google.com/functions/docs/calling/#event_triggers.<br>`resource` is a name or partial URI (e.g. "projects/my-project/topics/my-topic").<br>`retry` indicates whether the function should be retried upon failure. | <pre>object({<br>    event_type = string<br>    resource   = string<br>    retry      = bool<br>  })</pre> | `null` | no |
| <a name="input_function_trigger_http"></a> [function\_trigger\_http](#input\_function\_trigger\_http) | Trigger this function upon HTTP requests (POST, PUT, GET, DELETE, and OPTIONS).<br>Exactly one of either this field or `function_event_trigger` must be provided.<br><br>The URL of the cloud function will be the following:<br>`https://{google_region}-{google_project}.cloudfunctions.net/{function_name}`. | `bool` | `false` | no |
| <a name="input_function_invokers"></a> [function\_invokers](#input\_function\_invokers) | A list of additional identities permitted to use this specific cloud function.<br>Particularly useful for allowing "allUsers" to invoke an HTTP-triggered function.<br>Inherited permissions mean that adding yourself or your team is usually not necessary.<br><br>Possible identities listed here:<br>https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam#member/members<br><br>Each identity will be granted "roles/cloudfunctions.invoker" on the cloud function resource. | `set(string)` | `[]` | no |
| <a name="input_function_source_archive"></a> [function\_source\_archive](#input\_function\_source\_archive) | A GCS bucket/object pointing to a ZIP file containing the source code for the cloud function.<br>The source code must be at the root of the ZIP file, not inside an interior folder.<br><br>Exactly one of either this field or `function_source_repository` must be provided.<br><br>See https://cloud.google.com/functions/docs/writing#structuring_source_code<br>for more information. | <pre>object({<br>    archive_bucket = string<br>    archive_object = string<br>  })</pre> | `null` | no |
| <a name="input_function_source_repository"></a> [function\_source\_repository](#input\_function\_source\_repository) | A Cloud Source Repository reference containing the source code for the cloud function.<br>This can be an automatically-syncing mirror of a GitHub repo, just ping DevOps for help.<br><br>Exactly one of either this field or `function_source_archive` must be provided.<br><br>`repository_google_project` is the ID of the project where the repository resides.<br>`repository_name` is the name of the repository (if a mirror, usually `github_broadinstitute_...`).<br>`repository_tag` is the tag to check out (if a mirror, tags are synced from GitHub too).<br>`repository_path` is the relative path to the code itself (set to empty for repository root).<br><br>See https://cloud.google.com/functions/docs/writing#structuring_source_code<br>for more information. | <pre>object({<br>    repository_google_project = string<br>    repository_name           = string<br>    repository_tag            = string<br>    repository_path           = string<br>  })</pre> | `null` | no |
| <a name="input_function_vault_secrets"></a> [function\_vault\_secrets](#input\_function\_vault\_secrets) | Secrets from Vault to make available to the cloud function via Secret Manager.<br>For each `{vault_secret_json_key}` field extracted from Vault at `{vault_secret_path}`,<br>the function will have an environment variable `{env_var_for_secret_name}` containing the <br>full name of the Secret Manager "version" containing the secret value.<br><br>The cloud function's service account will be able to access these values--you may use<br>https://cloud.google.com/secret-manager/docs/reference/libraries without setting up<br>authentication. See README.md for more information. | <pre>map(object({<br>    vault_secret_path       = string<br>    vault_secret_json_key   = string<br>    env_var_for_secret_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_function_insecure_environment_variables"></a> [function\_insecure\_environment\_variables](#input\_function\_insecure\_environment\_variables) | Mapping of environment variables to be entered into the function's environment. <br>This is PLAIN TEXT and will be revealed during Terraform Plan: it is not suitable <br>for secrets, see function\_vault\_secrets for the proper method. | `map(any)` | `{}` | no |
| <a name="input_function_insecure_build_environment_variables"></a> [function\_insecure\_build\_environment\_variables](#input\_function\_insecure\_build\_environment\_variables) | Mapping of environment variables to be entered into the build-time environment.<br>This is PLAIN TEXT and will be revealed during Terraform Plan: it is not suitable <br>for secrets. | `map(any)` | `{}` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Optional description of the function. | `string` | `null` | no |
| <a name="input_function_available_memory_mb"></a> [function\_available\_memory\_mb](#input\_function\_available\_memory\_mb) | Optional memory (in MB) available to the function, defaults to 256. | `number` | `null` | no |
| <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout) | Optional timeout (in seconds) for the function, defaults to 60. | `number` | `null` | no |
| <a name="input_function_ingress_settings"></a> [function\_ingress\_settings](#input\_function\_ingress\_settings) | Optional value to control what traffic may reach the function:<br>`ALLOW_ALL`, `ALLOW_INTERNAL_ONLY`, or `ALLOW_INTERNAL_AND_GCLB` (Cloud Load Balancing).<br>The default behavior is `ALLOW_ALL`.<br><br>More information is available at <br>https://cloud.google.com/functions/docs/networking/network-settings. | `string` | `null` | no |
| <a name="input_function_labels"></a> [function\_labels](#input\_function\_labels) | An optional set of key/value label pairs to assign to the function resource.<br><br>Label keys must follow the requirements at<br>https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements. | `map(any)` | `null` | no |
| <a name="input_function_vpc_connector"></a> [function\_vpc\_connector](#input\_function\_vpc\_connector) | Optional VPC Network Connector for the cloud function to be able to connect to.<br>Format is `projects/*/locations/*/connectors/*` (fully qualified URI). | `string` | `null` | no |
| <a name="input_function_vpc_connector_egress_settings"></a> [function\_vpc\_connector\_egress\_settings](#input\_function\_vpc\_connector\_egress\_settings) | Optional egress settings for a VPC Network Connector, controlling what traffic<br>is diverted through it. May be either `ALL_TRAFFIC` or `PRIVATE_RANGES_ONLY`, <br>defaults to `PRIVATE_RANGES_ONLY`. | `string` | `null` | no |
| <a name="input_function_max_instances"></a> [function\_max\_instances](#input\_function\_max\_instances) | Optional limit on the number of function instances that can exist at once. | `number` | `null` | no |
| <a name="input_monitoring_channel_names"></a> [monitoring\_channel\_names](#input\_monitoring\_channel\_names) | Optional set of already-configured Cloud Monitoring channel display names to notify upon function failures. | `set(string)` | `[]` | no |
| <a name="input_monitoring_failure_trigger_count"></a> [monitoring\_failure\_trigger\_count](#input\_monitoring\_failure\_trigger\_count) | The number of failed executions in `{monitoring_failure_trigger_period}` that triggers an alert. | `number` | `1` | no |
| <a name="input_monitoring_failure_trigger_period"></a> [monitoring\_failure\_trigger\_period](#input\_monitoring\_failure\_trigger\_period) | The period of time to count failures in to compare with `{monitoring_failure_trigger_count}`. | `string` | `"60s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_service_account_email"></a> [function\_service\_account\_email](#output\_function\_service\_account\_email) | Email of the service account used for the cloud function |
| <a name="output_function_https_trigger_url"></a> [function\_https\_trigger\_url](#output\_function\_https\_trigger\_url) | When `function_trigger_http` is true, this is the URL of the cloud function.<br><br>The URL of the cloud function will be the following:<br>`https://{google_region}-{google_project}.cloudfunctions.net/{function_name}`. |

[//]: # (END_TF_DOCS)