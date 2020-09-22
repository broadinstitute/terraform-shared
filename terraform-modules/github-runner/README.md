This module creates some number of self-hosted GitHub runners for a specific repository. The runners have individual static IPs given in the module outputs, so the runners can be granted access to things like Kubernetes that require an CIDR allowlist.

Multiple instances of this module can be created with different labels, service accounts, or vault permissions if there's a desire to segment permissions. To simply create multiple runners with the same configuration, just set the `runners` variable to something higher than its default of `1`.

## Usage
```hcl
module "test_runner" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/github-runner?ref=github-runner-0.0.1"

  providers = {
    google = google.broad-gotc-dev
  }

  # Bucket names containing "google" are globally invalid,
  # used by example here to avoid referencing any foreign data
  vault-role-id-path   = "gs://some-google-bucket/role-id"
  vault-secret-id-path = "gs://some-google-bucket/secret-id"

  # A real value would need to have the token in a `token` field
  github-personal-access-token-path = "secret/dsde/gotc/some/path"

  repo            = "gotc-deploy"
  service-account = "ci-non-prod@broad-gotc-dev.iam.gserviceaccount.com"
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vault-role-id-path | A `gs://...` path that the instance's service account can read the vault role ID from | string | NULL | yes |
| vault-secret-id-path | A `gs://...` path that the instance's service account can read the vault secret ID from | string | NULL | yes |
| vault-server | The address of the vault server | string | https://clotho.broadinstitute.org:8200 | no |
| github-personal-access-token-path | A `secret/...` path within Vault to use to get a GH PAT to register the runner | string | NULL | yes |
| repo | The name of the GitHub repo to be a runner for, without the owner prefix | string | NULL | yes |
| labels | Labels to put on the runner in GitHub | set(string) | [] | no |
| service-account | The email of the service account to use on the instance | string | NULL | yes |
| actions-user | The username of the non-root to create to run actions as | string | "actions" | no |
| zone | The zone to provision the GCE instance in | string | "us-central1-a" | no |
| machine-type | The type of GCE instance to provision | string | "n1-standard-1" | no |
| boot-disk-size | The size of the GCE instance boot disk in gigabytes | number | 10 | no |
| runners | The number of individual instances to provision | number | 1 | no |
