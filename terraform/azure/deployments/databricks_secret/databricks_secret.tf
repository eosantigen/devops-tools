terraform {
  backend "azurerm" {}
  required_version = "~>1.1"
  required_providers {
    databrickslabs = {
      source = "databrickslabs/databricks"
      version = "0.5.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.96.0"
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
variable "secrets" {}
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

data "azurerm_databricks_workspace" "adb" {
  name                = var.databricks_workspace_name
  resource_group_name = var.databricks_resource_group_name
}

provider "databrickslabs" {
  host                              = data.azurerm_databricks_workspace.adb.workspace_url
  azure_workspace_resource_id       = data.azurerm_databricks_workspace.adb.id
  azure_client_id                   = var.ARM_CLIENT_ID
  azure_client_secret               = var.ARM_CLIENT_SECRET
  azure_tenant_id                   = var.ARM_TENANT_ID
}

# MODULES

module "secret" {
  source = "../../modules/databricks_resources/secret"
  secrets = var.secrets
}