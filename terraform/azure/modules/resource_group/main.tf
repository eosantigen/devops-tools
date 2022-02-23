/**
* Creates Azure Resource Group with optional IAM assignments.
*/

# --CAUTION

# UNCOMMENT THIS **ONLY IF YOU NEED TO IMPORT** THE FOLLOWING RESOURCES INTO THE STATE.
# OTHERWISE, IT IS INHERITED FROM THE PARENT MODULE/DEPLOYMENT.

# provider "azurerm" {
#     features {}
#     # subscription_id = var.client_subscription # USE WITH EXTRA *CAUTION - normally we switch the Subscription through az cli*.
#     skip_provider_registration = false
# }
# --CAUTION END

# RESOURCE GROUP

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_azure_location
  tags     = merge(var.common_tags, var.client_tags)
  timeouts {
    create  = "5m"
    read    = "5m"
    update  = "5m"
    delete  = "5m"
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