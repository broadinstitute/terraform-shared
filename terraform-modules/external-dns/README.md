# Module for creating DNS

- This module creates dynamic A record, CNAME and ip

### Prerequisite
- Terraform 0.12.6+

### Example Use
```
provider google-beta {
  alias = "target"
  credentials = file("account.json")
  project = "broad-jade-dev"
  region = "us-central1"
}

provider google-beta {
  alias = "dev-core"

  project = "broad-jade-dev"
  region = "us-central1"
}

data google_dns_managed_zone dev_zone {
  provider = google-beta.dev-core
  name = "datarepo-dev"
}

module dns_names {
  source = "../"
  providers = {
    google.ip = google-beta.target,
    google.dns = google-beta.dev-core
  }
  zone_gcp_name = data.google_dns_managed_zone.dev_zone.name
  zone_dns_name = data.google_dns_managed_zone.dev_zone.dns_name
  dns_names = ["cheese", "pizza"]
}
```
