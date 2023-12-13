# INPUT VARIABLES COMING FROM SOURCED MODULES - THESE HERE DO NOT NEED EXTRA DEFINITION HERE SINCE THEY HAVE ALREADY BEEN DEFINED IN THEIR EQUIVALENT BASE/SHARED MODULES. THEY JUST HAVE TO BE DECLARED HERE AS THEY ARE INPUT TO THE AKS "ROOT" MODULE.

variable "resource_group_name" {}
variable "resource_group_azure_location" {}
variable "iam_aks_cluster_admins" {}
variable "iam_aks_cluster_users" {}
variable "virtual_network_name" {}
variable "virtual_network_address_space" {}
variable "virtual_network_subnets" {}
variable "tags" {}
variable "common_tags" {}

# SPECIFIC TO THE BASE/SHARED MODULE

variable "cluster_name" {
  type        = string
  description = "(Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). AKS does not require an exact patch version to be specified, minor version aliases such as 1.22 are also supported. - The minor version's latest GA patch is automatically chosen in that case."
}

variable "default_node_pool_node_count" {
  type        = number
  description = "(Optional) The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "(Required) The size of the Virtual Machine, such as Standard_DS2_v2. temporary_name_for_rotation must be specified when attempting a resize."
}

variable "authorized_ip_ranges" {
  type        = set(string)
  description = "(Optional) Set of authorized IP ranges to allow access to API server, e.g. [\"198.51.100.0/24\"]. (without the backslashes! )"
}

variable "linux_profile_key_data" {
  type        = string
  description = "(Required) The Public SSH Key used to access the cluster."
}

variable "linux_profile_admin_username" {
  type        = string
  description = "(Required) The Admin Username for the Cluster. Changing this forces a new resource to be created."
}

# AKS - NODE POOLS

variable "nodepools" {
  type = map(any)
}