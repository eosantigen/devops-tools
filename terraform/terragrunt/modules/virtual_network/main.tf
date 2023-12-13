/**
* Creates Azure Virtual Network and Subnet(s).
*/

# VIRTUAL NETWORK

resource "azurerm_virtual_network" "virtual_network" {

  name                = var.virtual_network_name
  location            = var.virtual_network_location
  resource_group_name = var.virtual_network_resource_group_name
  address_space       = var.virtual_network_address_space
  tags                = merge(var.tags, var.common_tags)

  timeouts {
    create = "8m"
    read   = "8m"
    update = "8m"
    delete = "8m"
  }
}

# SUBNET

resource "azurerm_subnet" "subnet" {

  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [each.value.cidr]

  timeouts {
    create = "8m"
    read   = "8m"
    update = "8m"
    delete = "8m"
  }
}