# vault-approle


### var example
```
variable "approle" {
  type = map(object({token_policies = list(string), secret_id_num_uses = number, secret_id_ttl = number, secret_id_num_uses = number, token_num_uses = number}))
  default = {
    tf_test_approle = {
      token_policies = ["datarepo-dev-read"]
      secret_id_num_uses  = 0
      secret_id_ttl = 30
      token_num_uses = 10
    }
  }
}
```
