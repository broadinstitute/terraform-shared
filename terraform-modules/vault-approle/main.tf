resource "vault_approle_auth_backend_role" "approle" {
  for_each  = var.approle
  role_name      = "${each.key}"
  token_policies = each.value["token_policies"]
  secret_id_num_uses = each.value["secret_id_num_uses"]
  secret_id_ttl = each.value["secret_id_ttl"]
  token_num_uses = each.value["token_num_uses"]
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  for_each  = var.approle
  role_name = vault_approle_auth_backend_role.approle["${each.key}"].role_name
}
