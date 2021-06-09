resource "vault_approle_auth_backend_role" "approle" {
  for_each                = var.approle
  role_name               = "${each.key}"
  policies                = each.value["token_policies"]
  token_no_default_policy = lookup(each.value, "token_no_default_policy", true)
  secret_id_num_uses      = lookup(each.value, "secret_id_num_uses", null)
  secret_id_ttl           = lookup(each.value, "secret_id_ttl", null)
  token_num_uses          = lookup(each.value, "token_num_uses", null)
  token_ttl               = lookup(each.value, "token_ttl", null)
  token_max_ttl           = lookup(each.value, "token_max_ttl", null)
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  for_each  = var.approle
  role_name = vault_approle_auth_backend_role.approle["${each.key}"].role_name
}
