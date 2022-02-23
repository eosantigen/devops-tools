/**
* Creates Azure Virtual Network and Subnet.
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

# VIRTUAL NETWORK

resource "azurerm_virtual_network" "virtual_network" {

    name = var.virtual_network_name
    location = var.virtual_network_location
    resource_group_name = var.virtual_network_resource_group_name
    address_space = var.virtual_network_address_space
    tags = merge(var.common_tags, var.client_tags)
    timeouts {
        create  = "8m"
        read    = "8m"
        update  = "8m"
        delete  = "8m"
    }
}

# SUBNET

resource "azurerm_subnet" "subnet" {
    for_each = var.subnets

    name = each.value.name
    resource_group_name = var.subnet_resource_group_name
    virtual_network_name = var.subnet_virtual_network_name
    address_prefixes =  [each.value.cidr]
    service_endpoints = ["Microsoft.Storage"]

    # CAUTION -  The following delegation is only for when building for databricks
    # needs refactoring  to get values dynamically.
    dynamic "delegation" {
        for_each = each.value.service_delegation == "true" ? [1] : []
        
        content {
            name = "delegation"
############################ CAUTION ! ######################################
# The following service_delegation content is hard-coded to match ONLY A DATABRICKS DEPLOYMENT .
# Must be changed accordingly EVERYTIME the for_each statement above is going to be "true".
# (until an improvement is made.)
############################################################################
            service_delegation {
                name    = "Microsoft.Databricks/workspaces"
                actions = [
                    "Microsoft.Network/virtualNetworks/subnets/join/action",
                    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
                    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
                ]
            }        
        }
    }

    depends_on = [azurerm_virtual_network.virtual_network]

    timeouts {
        create  = "8m"
        read    = "8m"
        update  = "8m"
        delete  = "8m"
    }
}