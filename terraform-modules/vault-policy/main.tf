data "vault_policy_document" "policy" {
  for_each = var.policy
  rule {
    path         = each.value["path"]
    capabilities = each.value["capabilities"]
  }
}

resource "vault_policy" "policy" {
  for_each    = var.policy
  name        = "${each.key}"
  policy      = data.vault_policy_document.policy["${each.key}"].hcl
}
