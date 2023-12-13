# LOCAL VARIABLES
# For variables that need to be string interpolated, as TF itself does not support it within a .tfvars file, by design.

locals {
  dns_prefix = "eosantigen-${var.cluster_name}"
}

# RESOURCE GROUP

module "resource_group" {

  source = "../resource_group"

  resource_group_name                   = var.resource_group_name
  resource_group_azure_location         = var.resource_group_azure_location
  resource_group_iam_aks_cluster_admins = toset(var.iam_aks_cluster_admins)
  resource_group_iam_aks_cluster_users  = toset(var.iam_aks_cluster_users)
  tags                                  = merge(var.tags, var.common_tags)
}

# VIRTUAL NETWORK

module "virtual_network" {

  source = "../virtual_network"

  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = module.resource_group.name
  virtual_network_location            = var.resource_group_azure_location
  virtual_network_address_space       = var.virtual_network_address_space
  subnets                             = var.virtual_network_subnets
  subnet_resource_group_name          = module.resource_group.name
  subnet_virtual_network_name         = var.virtual_network_name
  tags                                = merge(var.tags, var.common_tags)
}

# AKS

resource "azurerm_kubernetes_cluster" "aks" {
  
  name                   = var.cluster_name
  dns_prefix             = local.dns_prefix
  location               = var.resource_group_azure_location
  resource_group_name    = module.resource_group.name
  kubernetes_version     = var.kubernetes_version
  local_account_disabled = true

  network_profile {
    network_plugin = "kubenet"
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = toset(var.iam_aks_cluster_admins)
    managed                = true
  }

  default_node_pool {
    name                 = "system"
    os_disk_type         = "Ephemeral"
    orchestrator_version = var.kubernetes_version
    node_count           = var.default_node_pool_node_count
    vm_size              = var.default_node_pool_vm_size
    vnet_subnet_id       = module.virtual_network.subnet_id[0]
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = var.linux_profile_admin_username
    ssh_key {
      key_data = var.linux_profile_key_data
    }
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  tags = merge(var.tags, var.common_tags)
}

# AKS NODE POOLS

resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {

  for_each = var.nodepools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.virtual_network.subnet_id[0]
  name                  = each.key
  node_labels           = each.value.labels
  vm_size               = each.value.size
  node_count            = each.value.nodes
  enable_auto_scaling   = each.value.auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  orchestrator_version  = var.kubernetes_version

  tags = merge(var.tags, var.common_tags)
}