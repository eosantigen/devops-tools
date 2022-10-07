resource "databricks_secret_scope" "secret_scope" {

  provider = databrickslabs
  for_each = var.secret_scopes
  name = each.key
}