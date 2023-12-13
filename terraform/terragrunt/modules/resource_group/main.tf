/**
* Creates Azure Resource Group with optional IAM assignments.
* For example, if you feed it the variable "resource_group_iam_aks_cluster_admins" and it contains values, then it will populate it accordingly. If you ommit that variable, it will not break.
*/

# RESOURCE GROUP

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_azure_location
  tags     = merge(var.tags, var.common_tags)
  timeouts {
    create = "5m"
    read   = "5m"
    update = "5m"
    delete = "5m"
  }
}

# RESOURCE GROUP - IAM

resource "azurerm_role_assignment" "resource_group_owners" {
  count                = length(var.resource_group_iam_owners)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Owner"
  principal_id         = var.resource_group_iam_owners[count.index]
}

resource "azurerm_role_assignment" "resource_group_contributors" {
  count                = length(var.resource_group_iam_contributors)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Contributor"
  principal_id         = var.resource_group_iam_contributors[count.index]
}

resource "azurerm_role_assignment" "resource_group_readers" {
  count                = length(var.resource_group_iam_readers)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Reader"
  principal_id         = var.resource_group_iam_readers[count.index]
}

# RESOURCE GROUP IAM - STORAGE

resource "azurerm_role_assignment" "resource_group_storage_blob_data_contributors" {
  count                = length(var.resource_group_iam_storage_blob_data_contributors)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.resource_group_iam_storage_blob_data_contributors[count.index]
}

resource "azurerm_role_assignment" "resource_group_storage_blob_data_readers" {
  count                = length(var.resource_group_iam_storage_blob_data_readers)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.resource_group_iam_storage_blob_data_readers[count.index]
}

# RESOURCE GROUP IAM - AKS

resource "azurerm_role_assignment" "resource_group_aks_cluster_admins" {
  count                = length(var.resource_group_iam_aks_cluster_admins)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = var.resource_group_iam_aks_cluster_admins[count.index]
}

resource "azurerm_role_assignment" "resource_group_aks_cluster_users" {
  count                = length(var.resource_group_iam_aks_cluster_users)
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.resource_group_iam_aks_cluster_users[count.index]
}