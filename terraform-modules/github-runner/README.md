This module creates some number of self-hosted GitHub runners for a specific repository. The runners have individual static IPs given in the module outputs, so the runners can be granted access to things like Kubernetes that require an CIDR allowlist. Use [labels in your GitHub action](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow#using-self-hosted-runners-in-a-workflow) to refer to the runners you create with this module. 

## Usage
```hcl
module "test_runner" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/github-runner?ref=github-runner-0.1.0"

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

It can take a minute or so after Terraform "creates" the instance resources for the runners to actually appear in GitHub (Terraform doesn't track the startup script that does the configuring).

Multiple instances of this module can be created with different labels, service accounts, or Vault auth if there's a desire to segment permissions. To simply create multiple runners with the same configuration, just set the `runners` variable to something higher than its default of `1`.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vault-role-id-path | A `gs://...` path that the instance's service account can read the vault role ID from | string | NULL | yes |
| vault-secret-id-path | A `gs://...` path that the instance's service account can read the vault secret ID from | string | NULL | yes |
| vault-server | The address of the vault server | string | https://clotho.broadinstitute.org:8200 | no |
| github-personal-access-token-path | A `secret/...` path within Vault to use to get a GH PAT to register the runner | string | NULL | yes |
| repo | The name of the GitHub repo to be a runner for, without the owner prefix | string | NULL | yes |
| runner-labels | Labels to put on the runner in GitHub | set(string) | [] | no |
| service-account | The email of the service account to use on the instance | string | NULL | yes |
| service-account-scopes | Scopes for the service account to have on the instance | ["cloud-platform", "userinfo-email", "https://www.googleapis.com/auth/userinfo.profile"] | no |
| actions-user | The username of the non-root to create to run actions as | string | "actions" | no |
| zone | The zone to provision the GCE instance in | string | "us-central1-a" | no |
| machine-type | The type of GCE instance to provision | string | "n1-standard-1" | no |
| boot-disk-size | The size of the GCE instance boot disk in gigabytes | number | 10 | no |
| runners | The number of individual instances to provision | number | 1 | no |

## Outputs
| Name | Description | Type |
|------|-------------|:----:|
| instance-external-ips | The static public IPs of the runners | list(string) |
| instance-external-cidrs | The static public IPs of the runners in CIDR format | list(string) |
| instance-names | The names of the runners | list(string) |

## Features
Out-of-the-box on each runner you get:
- A static Broad-controlled public IP
- Vault preinstalled and authenticated (via the given role/secret ID paths)
- GCP utilities preinstalled and authenticated (for `service-account` with `service-account-scopes`)
- Docker (and kubectl) preinstalled and `gcloud` set as a credential helper
- Automatic registration with the target GitHub repo on startup (and de-registration on shutdown)
- Automatic restarts every night at 3 AM to update everything to latest version (Docker, Vault, kubectl, OS via `apt-get update`, GitHub Action Runner software)

## Debugging
If things go horribly wrong, you can use GCP UI to find the problematic instance and grab the `gcloud` command to SSH in via non-split VPN.

To see logs . . .
- of the startup script, use `sudo journalctl -u google-startup-scripts.service`
- of the Vault agent, use `less /vault-agent.log`
- of the runner service, use `sudo journalctl -u $(cat /runner/.service)`
- of the runner application, look in the files in `ls -la /runner/_diag | grep Runner_`
  - The runner application is always used as a service, so should be the same info, just might be easier to browse one versus the other
- of individual jobs, look in the files in `ls -la /runner/_diag | grep Worker_`

Keep in mind that you should think of the instances as essentially ephemeral (they're not for logging purposes, but Terraform can destroy them whenever). To make a change stick you'll want to encode it in Terraform or the scripts here, which are run nightly.