data "vault_generic_secret" "original_audience_secret" {
   path = var.original_audience_secret_path
}

resource "vault_generic_secret" "new_audience_secret" {
  path = var.new_audience_secret_path
  data_json = <<EOT
  { "client_ids": ${jsonencode(merge(jsondecode(data.vault_generic_secret.original_audience_secret.data["client_ids"]), var.values_to_merge))}
}
EOT
}

output "secret_path" {
  value = var.new_audience_secret_path
}

output "audiences" {
  value = merge(jsondecode(data.vault_generic_secret.original_audience_secret.data["client_ids"]), var.values_to_merge)
}
