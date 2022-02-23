/**
* Creates an Azure Databricks workspace with optional VNet injection (https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/vnet-inject).
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


data "azurerm_virtual_network" "databricks_vnet" {
    name = var.databricks_vnet_name
    resource_group_name = var.databricks_resource_group_name
}

data "azurerm_subnet" "databricks_private_subnet" {
    name = "private"
    resource_group_name = var.databricks_resource_group_name
    virtual_network_name = var.databricks_vnet_name
}

data "azurerm_subnet" "databricks_public_subnet" {
    name = "public"
    resource_group_name = var.databricks_resource_group_name
    virtual_network_name = var.databricks_vnet_name
}

resource "azurerm_network_security_group" "databricks_nsg" {
  name                = var.databricks_network_security_group_name
  location            = var.databricks_location
  resource_group_name = var.databricks_resource_group_name

  tags                = merge(var.common_tags, var.client_tags)
  depends_on = [
      data.azurerm_subnet.databricks_private_subnet,
      data.azurerm_subnet.databricks_public_subnet,
  ]
}

data "azurerm_network_security_group" "databricks_nsg" {
    name = var.databricks_network_security_group_name
    resource_group_name = var.databricks_resource_group_name
    depends_on = [
        azurerm_network_security_group.databricks_nsg,
    ]
}

resource "azurerm_subnet_network_security_group_association" "databricks_public_nsg" {
  subnet_id                 = data.azurerm_subnet.databricks_public_subnet.id
  network_security_group_id = data.azurerm_network_security_group.databricks_nsg.id
  depends_on = [
      azurerm_network_security_group.databricks_nsg,
  ]
}


resource "azurerm_subnet_network_security_group_association" "databricks_private_nsg" {
  subnet_id                 = data.azurerm_subnet.databricks_private_subnet.id
  network_security_group_id = data.azurerm_network_security_group.databricks_nsg.id
  depends_on = [
      azurerm_network_security_group.databricks_nsg,
  ]
}

# resource "azurerm_public_ip" "databricks" {
#   name                    = var.databricks_nat_gateway_public_ip_name
#   location                = var.databricks_location
#   resource_group_name     = var.databricks_resource_group_name
#   allocation_method       = "Static"
#   sku                     = "Standard"
#   ip_version              = "IPv4"
#   idle_timeout_in_minutes = 4

#   tags = merge(var.common_tags, var.client_tags)
# }

# resource "azurerm_nat_gateway" "databricks" {
#   name                    = var.databricks_nat_gateway_name
#   location                = var.databricks_location
#   resource_group_name     = var.databricks_resource_group_name
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 4

#   tags = merge(var.common_tags, var.client_tags)
# }

# resource "azurerm_nat_gateway_public_ip_association" "databricks" {
#   nat_gateway_id       = azurerm_nat_gateway.databricks.id
#   public_ip_address_id = azurerm_public_ip.databricks.id
# }

# resource "azurerm_subnet_nat_gateway_association" "databricks_private_subnet" {
#   subnet_id      = data.azurerm_subnet.databricks_private_subnet.id
#   nat_gateway_id = azurerm_nat_gateway.databricks.id
# }

# resource "azurerm_subnet_nat_gateway_association" "databricks_public_subnet" {
#   subnet_id      = data.azurerm_subnet.databricks_public_subnet.id
#   nat_gateway_id = azurerm_nat_gateway.databricks.id
# }


resource "azurerm_databricks_workspace" "adb" {

    name = var.databricks_name
    resource_group_name = var.databricks_resource_group_name
    location = var.databricks_location
    sku = var.databricks_sku
    custom_parameters {
        no_public_ip  = true
        virtual_network_id = data.azurerm_virtual_network.databricks_vnet.id
        public_subnet_name = "public"
        private_subnet_name = "private"
        private_subnet_network_security_group_association_id = data.azurerm_subnet.databricks_private_subnet.id
        public_subnet_network_security_group_association_id  = data.azurerm_subnet.databricks_public_subnet.id
    }

    tags = merge(var.common_tags, var.client_tags)

    timeouts {
        create  = "15m"
        read    = "15m"
        update  = "15m"
        delete  = "15m"
    }
    depends_on = [
        azurerm_subnet_network_security_group_association.databricks_public_nsg,
        azurerm_subnet_network_security_group_association.databricks_private_nsg,
    ]
}

# FINALLY, ADD A CHERRY TO THE PIE

resource "null_resource" "notify_slack" {

 provisioner "local-exec" {

   working_dir = "../../../ansible/notify_slack/plays" # EXTRA CARE - relative to this file . May not work in other files.
   command = "${var.ANSIBLE_EXECUTABLE_PATH}/ansible-playbook databricks.yaml -e workspace_url=${azurerm_databricks_workspace.adb.workspace_url} -e client_name=${lookup(var.client_tags, "ClientName")}"
 }
}