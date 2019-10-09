## Google Project

This module creates a Google Project, optionally enables APIs, and
creates or adds permissions to service accounts.

### Example

```
module "my-project" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/google-project?ref=google-project-0.0.1-tf-0.12"

  project_name = "my-project-name"
  folder_id = var.google_folder_id
  billing_account_id = var.billing_project_id
  apis_to_enable = [
   "logging.googleapis.com",
   "monitoring.googleapis.com",
  ]
  service_accounts_to_grant = [
    {
      email = var.my_sa_email_str
      sa_roles = [
        "Editor"
      ]
    }
  ] 
  service_accounts_to_create_with_keys = [
    {
      sa_name = var.my_key_sa_name_str
      sa_roles = [
        "Editor"
      ]
      key_vault_path = var.path_to_key_in_vault_str
    }
  ]
  service_accounts_to_create_without_keys = [
    {
      sa_name = var.my_no_key_sa_name_str
      sa_roles = [
        "Editor"
      ]
    }
  ]
}
```
