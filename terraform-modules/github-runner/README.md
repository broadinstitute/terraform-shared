This module creates some number of self-hosted GitHub runners for a specific repository. The runners have individual static IPs given in the module outputs, so the runners can be granted access to things like Kubernetes that require an CIDR allowlist. Use [labels in your GitHub action](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow#using-self-hosted-runners-in-a-workflow) to refer to the runners you create with this module. 

## Usage
```hcl
module "test_runner" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/github-runner?ref=github-runner-0.2.1"

  providers = {
    google = google.broad-gotc-dev
  }

  # SA for both getting the Vault IDs below and anything else needed
  # within actions (including broadinstitute Docker)
  service-account = "ci-non-prod@broad-gotc-dev.iam.gserviceaccount.com"

  # Vault access for both getting the GitHub token below and anything else
  # needed within actions
  vault-role-id-path   = "gs://some-google-bucket/role-id"
  vault-secret-id-path = "gs://some-google-bucket/secret-id"

  # Needs to have the token in a `token` field and must at least grant
  # admin access to the target repo
  github-personal-access-token-path = "secret/dsde/gotc/some/path"

  # Must be within broadinstitute's org and should be private
  repo = "gotc-deploy"
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
| service-account-scopes | Scopes for the service account to have on the instance | list(string) | ["cloud-platform", "userinfo-email", "https://www.googleapis.com/auth/userinfo.profile"] | no |
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
  - Docker runs in [rootless mode](https://docs.docker.com/engine/security/rootless/) to simplify permissions and enhance security -- the root user inside containers maps to the normal user that runs actions on the host
- Automatic registration with the target GitHub repo on startup (and de-registration on shutdown)
- Automatic restarts every night at 3 AM to update everything to latest version (Docker, Vault, kubectl, OS via `apt-get update`, GitHub Action Runner software)

## Debugging
If things go horribly wrong, you can use GCP UI to find the problematic instance and grab the `gcloud` command to SSH in via non-split VPN.

To see logs . . .
- of the startup script, use `sudo journalctl -u google-startup-scripts.service`
- of the Vault agent, use `less /vault-agent.log`
- of the Docker daemon, use `less /docker.log`
- of the runner service, use `sudo journalctl -u $(cat /runner/.service)`
- of the runner application, look in the files in `ls -la /runner/_diag | grep Runner_`
  - The runner application is always used as a service, so should be the same info, just might be easier to browse one versus the other
- of individual jobs, look in the files in `ls -la /runner/_diag | grep Worker_`

The instances should be considered ephemeral because Terraform will destroy and recreate them at will to produce expected `apply` behavior.

**If a runner appears broken in a way that the nightly restarts won't fix,** `taint` the `random_id.runner-id` resource inside this module: you'll get completely fresh runners with the same external IPs as the old ones. Destroyed runners are always cleaned up as best as possible.
