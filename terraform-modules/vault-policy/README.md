# vault-policy

```
variable "policy" {
  type = map(object({path = string, capabilities = list(string)}))
  default = {
    tf_policy_test = {
      path = "secret/*"
      capabilities  = ["create", "read", "update", "delete", "list"]
    }
  }
}
```
