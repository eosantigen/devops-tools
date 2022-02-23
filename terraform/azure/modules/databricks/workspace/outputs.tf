output "workspace_name" {
  description = "The name of the Databricks workspace."
  value       = azurerm_databricks_workspace.adb.name
}

output "workspace_url" {
  description = "The workspace URL which is of the format 'adb-{workspace_id}.{random}.azuredatabricks.net'."
  value       = azurerm_databricks_workspace.adb.workspace_url
}