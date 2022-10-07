resource "databricks_secret" "secret" {

  provider = databrickslabs

  for_each = var.secrets
  
  scope        = each.value.scope
  key          = each.key
  string_value = each.value.value

}