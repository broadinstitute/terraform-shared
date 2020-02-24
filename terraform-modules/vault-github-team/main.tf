resource "vault_github_team" "githubteam" {
  for_each = var.github_team
  team     = each.key
  policies = each.value["policies"]
}
