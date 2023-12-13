terraform {
    backend "azurerm" {}
    required_version = "~>1.1"
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.96.0"
        }
        null = {
            source = "hashicorp/null"
            version = "3.1.0"
        }
    }
}

provider "null" {
  # Configuration options
}

provider "azurerm" {
    features {}
    skip_provider_registration = false
    client_id = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
    subscription_id = var.ARM_SUBSCRIPTION_ID
    tenant_id = var.ARM_TENANT_ID
}

# VARIABLES DECLARATION

## AUTH
variable ARM_CLIENT_ID {}
variable ARM_CLIENT_SECRET {}
variable ARM_TENANT_ID {}
variable ARM_SUBSCRIPTION_ID {}

## GENERAL 
variable "client_tags" {}
variable "common_tags" {}
variable "ANSIBLE_EXECUTABLE_PATH" {}

# STORAGE ACCOUNT GLOBAL AND DATALAKE
variable storage_account_network_rules_ip_rules {}
variable storage_account_network_rules_default_action {}
variable storage_account_resource_group_iam_contributors {}
variable storage_account_resource_group_iam_readers {}
variable storage_account_resource_group_iam_storage_blob_data_readers {}
variable storage_account_resource_group_iam_storage_blob_data_contributors {}
variable storage_account_datalake_name {}
variable storage_account_datalake_resource_group_name {}
variable storage_account_datalake_location {}
variable storage_account_datalake_kind {}
variable storage_account_datalake_account_tier {}
variable storage_account_datalake_replication_type {}
variable storage_account_datalake_access_tier {}
variable storage_account_datalake_blob_public_access {}
variable storage_account_datalake_shared_access_key {}
variable storage_account_datalake_hns {}
variable storage_account_datalake_nfs {}

## CONTAINERS

variable storage_account_datalake_container {}
variable storage_account_datalake_container_access_type {}

# DATABRICKS - OPTIONAL

variable databricks_vnet_name {}
variable databricks_resource_group_name {}


## DATA RETRIEVAL - OPTIONAL

data "azurerm_subnet" "databricks_public_subnet" {
   name = "public"
   virtual_network_name = var.databricks_vnet_name
   resource_group_name = var.databricks_resource_group_name
}

## MODULES
module "resource_group" {
    source = "../../modules/resource_group"
    resource_group_name = var.storage_account_datalake_resource_group_name
    resource_group_azure_location = var.storage_account_datalake_location
    resource_group_iam_contributors = var.storage_account_resource_group_iam_contributors
    resource_group_iam_readers = var.storage_account_resource_group_iam_readers
    resource_group_iam_storage_blob_data_contributors = var.storage_account_resource_group_iam_storage_blob_data_contributors
    resource_group_iam_storage_blob_data_readers = var.storage_account_resource_group_iam_storage_blob_data_readers
    common_tags = var.common_tags
    client_tags = var.client_tags
}

module "datalake" {
    source = "../../modules/storage"
    storage_account_name = var.storage_account_datalake_name
    storage_account_resource_group_name = var.storage_account_datalake_resource_group_name
    storage_account_location = var.storage_account_datalake_location
    storage_account_kind = var.storage_account_datalake_kind
    storage_account_tier = var.storage_account_datalake_account_tier
    storage_account_replication_type = var.storage_account_datalake_replication_type
    storage_account_access_tier = var.storage_account_datalake_access_tier
    storage_account_blob_public_access = var.storage_account_datalake_blob_public_access
    storage_account_shared_access_key = var.storage_account_datalake_shared_access_key
    storage_account_hns = var.storage_account_datalake_hns
    storage_account_nfs = var.storage_account_datalake_nfs
    storage_account_network_rules_default_action = var.storage_account_network_rules_default_action
    storage_account_network_rules_ip_rules = var.storage_account_network_rules_ip_rules
    storage_account_network_rules_virtual_network_subnet_ids = [
        data.azurerm_subnet.databricks_public_subnet.id,
    ]
    storage_container = toset(var.storage_account_datalake_container)
    storage_container_access_type = var.storage_account_datalake_container_access_type
    common_tags = var.common_tags
    client_tags = var.client_tags
    ANSIBLE_EXECUTABLE_PATH = var.ANSIBLE_EXECUTABLE_PATH

    depends_on = [module.resource_group]
}