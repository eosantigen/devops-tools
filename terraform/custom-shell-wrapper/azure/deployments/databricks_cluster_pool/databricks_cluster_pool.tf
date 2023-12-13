terraform {
  backend "azurerm" {}
  required_version = "~>1.1"
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.5.4"
    }
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
variable "databricks_resource_group_name" {}
variable "databricks_workspace_name" {}

# PROVIDERS CONFIG

provider "azurerm" {
  features {}
  skip_provider_registration  = true
  client_id                   = var.ARM_CLIENT_ID
  client_secret               = var.ARM_CLIENT_SECRET
  subscription_id             = var.ARM_SUBSCRIPTION_ID
  tenant_id                   = var.ARM_TENANT_ID
}

data "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = var.databricks_resource_group_name
}

provider "databricks" {
  host                        = azurerm_databricks_workspace.this.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.this.id
  client_id                   = var.ARM_CLIENT_ID
  client_secret               = var.ARM_CLIENT_SECRET
  tenant_id                   = var.ARM_TENANT_ID
}

# MODULES

module "cluster_pool" {
  source = "../../../modules/databricks_resources/cluster_pool"
  cluster_pools = var.cluster_pools
  common_tags = var.common_tags
  client_tags = var.client_tags
}