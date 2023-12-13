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

## DATABRICKS
# variable databricks_nat_gateway_public_ip_name {}
# variable databricks_nat_gateway_name {}
variable databricks_network_security_group_name {}
variable databricks_resource_group_name {}
variable databricks_resource_group_azure_location {}
variable databricks_resource_group_iam_contributors {}
variable databricks_resource_group_iam_readers {}
variable databricks_vnet_name {}
variable databricks_vnet_address_space {}
variable databricks_subnets {}
variable databricks_workspace_name {}
variable databricks_workspace_sku {}

## MODULES
module "resource_group" {
    source = "../../modules/resource_group"
    resource_group_name = var.databricks_resource_group_name
    resource_group_azure_location = var.databricks_resource_group_azure_location
    resource_group_iam_contributors = var.databricks_resource_group_iam_contributors
    resource_group_iam_readers = var.databricks_resource_group_iam_readers
    common_tags = var.common_tags
    client_tags = var.client_tags
}


module "network" {
    source = "../../modules/databricks/network"
    virtual_network_name = var.databricks_vnet_name
    virtual_network_location = var.databricks_resource_group_azure_location
    virtual_network_resource_group_name = var.databricks_resource_group_name
    virtual_network_address_space = var.databricks_vnet_address_space
    subnets  = var.databricks_subnets
    subnet_resource_group_name = var.databricks_resource_group_name
    subnet_virtual_network_name = var.databricks_vnet_name
    common_tags = var.common_tags
    client_tags = var.client_tags

    depends_on = [module.resource_group,]
}


module "workspace" {
    source = "../../modules/databricks/workspace"
    databricks_name = var.databricks_workspace_name
    databricks_resource_group_name = var.databricks_resource_group_name
    databricks_location = var.databricks_resource_group_azure_location
    databricks_sku = var.databricks_workspace_sku
    databricks_network_security_group_name = var.databricks_network_security_group_name
    databricks_vnet_name = var.databricks_vnet_name
    # databricks_nat_gateway_public_ip_name = var.databricks_nat_gateway_public_ip_name
    # databricks_nat_gateway_name  = var.databricks_nat_gateway_name
    common_tags = var.common_tags
    client_tags = var.client_tags
    ANSIBLE_EXECUTABLE_PATH = var.ANSIBLE_EXECUTABLE_PATH

    depends_on = [module.network,]

}