# vault-github-team

### var example
```
variable "github_team" {
  type = map(object({policies = list(string)}))
  default = {
    jadeteam = {
      policies = ["datarepo-dev-read"]
    }
  }
}
```
