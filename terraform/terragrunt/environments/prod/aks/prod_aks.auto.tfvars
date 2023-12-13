# RESOURCE GROUP

resource_group_name           = ""
resource_group_azure_location = ""

# VIRTUAL NETWORK

virtual_network_name = ""
virtual_network_address_space = [
  "",
]
virtual_network_subnets = {
  aks = {
    name = ""
    cidr = ""
  }
}

# TAGS

tags = {
  Environment = "stage"
}

# AKS

cluster_name                 = ""
kubernetes_version           = ""
default_node_pool_node_count = 1
default_node_pool_vm_size    = ""

# AKS - NODE POOLS

nodepools = {
  # applications = {
  #   labels       = { "applications" : true }
  #   size         = ""
  #   nodes        = 1
  #   auto_scaling = true
  #   min_count    = 1
  #   max_count    = 3
  # }
  timescaledb = {
    labels       = { "databases" : true }
    size         = "Standard_E8bds_v5"
    nodes        = 1
    auto_scaling = false
    min_count    = null
    max_count    = null
  }
}