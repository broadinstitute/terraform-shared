This module creates some number of self-hosted GitHub runners for a specific repository. The runners have individual static IPs given in the module outputs, so the runners can be granted access to things like Kubernetes that require an CIDR allowlist.

## Usage
```hcl
module "test_runner" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/github-runner?ref=github-runner-0.0.1"

  providers = {
    default = google
  }

  # Bucket names containing "google" are globally invalid,
  # used by example here to avoid referencing any foreign data
  vault-role-id-path   = "gs://some-google-bucket/role-id"
  vault-secret-id-path = "gs://some-google-bucket/secret-id"

  # A real value would need to have the token in a `token` field
  github-personal-access-token-path = "secret/dsde/gotc/some/path"

  repo            = "gotc-deploy"
  service-account = "ci-prod@broad-gotc-prod.iam.gserviceaccount.com"
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vault-role-id-path | A `gs://...` path that the instance's service account can read the vault role ID from | string | NULL | yes |
| vault-secret-id-path | A `gs://...` path that the instance's service account can read the vault secret ID from | string | NULL | yes |
| github-personal-access-token-path | A `secret/...` path within Vault to use to get a GH PAT to register the runner | string | NULL | yes |
| repo | The name of the GitHub repo to be a runner for, without the owner prefix | string | NULL | yes |
| service-account | he email of the service account to use on the instance | string | NULL | yes |
| zone | The zone to provision the GCE instance in | string | "us-central1-a" | no |
| machine-type | The type of GCE instance to provision | string | "n1-standard-1" | no |
| boot-disk-size | The size of the GCE instance boot disk in gigabytes | number | 10 | no |
| runners | The number of individual instances to provision | number | 1 | no |

## Limitations

Right now, this module is unique to a repository, meaning that there isn't a concept of different types of self-hosted runners in a single repository. In other words, only one instance of this module may target a given repository. To make more runners with the same configuration, the `count` can be incremented.

This is a limitation because there may be utility in having different self-hosted runners run different actions. This presumably means varying some of the following within the runners on a repo:
- The Vault authentication it is given
- The GCP service account is is given

To remove this limitation, the following would need to take place:
- Names of the static addresses and instances would need to be also based on the vault paths and GCP SA so as to avoid collisions
- Interaction with the GitHub API would be needed to specifically label the runners to differentiate them (they are automatically just given a self-hosted label, which isn't sufficient if they aren't all the same)
