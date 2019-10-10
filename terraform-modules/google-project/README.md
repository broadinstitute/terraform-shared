## Google Project

This module creates a Google Project, optionally enables APIs, and
creates or adds permissions to service accounts.

### Example

```
module "my-project" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/google-project?ref=google-project-0.0.1-tf-0.12"

  project_name = "my-project-name"
  folder_id = var.google_folder_id_str
  billing_account_id = var.billing_project_id_str
  apis_to_enable = [
   "logging.googleapis.com",
   "monitoring.googleapis.com",
  ]
  service_accounts_to_create_without_keys = [var.sa_nokey_name_str]
  service_accounts_to_create_with_keys = [
    {
      sa_name = var.sa_1_name_str
      key_vault_path = var.sa_1_vault_path_str
    }
  ]
  roles_to_grant_by_email_and_type = [{
    role = "roles/editor",
    email = var.sa_2_email
    id_type = "" // defaults to "serviceAccount", can be serviceAccount, user, group, or domain
  }]
  service_accounts_to_grant_by_name_and_project = [{
    sa_role = "roles/editor"
    sa_name = var.sa_1_name_str
    sa_project = "" // defaults to the created project
  }]
}
```
