# VIRTUAL NETWORK

variable "virtual_network_name" {
  type        = string
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  validation {
    condition = can(regex("(?i:vnet-\\w)", var.virtual_network_name))
    error_message = "Each Virtual Network must start with vnet-, contain the service-name as eg -databricks, and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "virtual_network_resource_group_name" {
  type = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  validation {
    condition = can(regex("(?i:rg-\\w)", var.virtual_network_resource_group_name))
    error_message = "Each Resource Group must start with rg-, include the desired Resource Type i.e. -databricks and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
  validation {
    condition     = can([for a in var.virtual_network_address_space : tonumber(regex("/(\\d+)", a)[0]) <= 27])
    error_message = "The CIDR prefix for the virtual network must be at least /27 (allows for 30 addresses - 5 Azure reserved = 25)."
  }
}

variable "virtual_network_location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

# SUBNET

variable "subnets" {
  type        = map(any)
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
  # validation {
  #   condition = can([for s in var.subnet_name : regex("(?i:subnet-\\w))", s)])
  #   error_message = "Each subnet name must start with subnet-, contain the service-name as eg -databricks, and end with -<CLIENT_NAME>. Case insensitive."
  # }
}

variable "subnet_resource_group_name" {
  type = string
  description = "(Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
  validation {
    condition = can(regex("(?i:rg-\\w)", var.subnet_resource_group_name))
    error_message = "Each Resource Group must start with rg-, include the desired Resource Type i.e. -databricks and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "subnet_virtual_network_name" {
  type = string
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
  validation {
    condition = can(regex("(?i:vnet-\\w)", var.subnet_virtual_network_name))
    error_message = "Each Virtual Network must start with vnet-, contain the service-name as eg -databricks, and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefix(es) to use for the subnet."
  default = []
  # validation {
  #   condition     = tonumber(regexall("/(\\d+)", var.subnet_address_prefixes)) <= 27
  #   error_message = "The CIDR prefix for the subnet must be at least /27 (allows for 30 addresses - 5 Azure reserved = 25)."
  # }
}

# COMMON

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Common tags."
  default     = {}
}

variable "client_tags" {
  type        = map(string)
  description = "(Optional) Client tags."
  default     = {}
}