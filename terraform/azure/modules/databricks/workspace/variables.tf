# DATABRICKS

variable "databricks_name" {
    type = string
    description = "(Required) Specifies the name of the Databricks Workspace resource. Changing this forces a new resource to be created."
    validation {
        condition = can(regex("(?i:adb-\\w)", var.databricks_name))
        error_message = "Each Databricks must start with adb-, and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "databricks_resource_group_name" {
    type = string
    description = "(Required) The name of the Resource Group in which the Databricks Workspace should exist. Changing this forces a new resource to be created."
    validation {
        condition = can(regex("(?i:rg-\\w)", var.databricks_resource_group_name))
        error_message = "Each Resource Group must start with rg-, include the desired Resource Type i.e. -databricks and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "databricks_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource has to be created. Changing this forces a new resource to be created."
}

variable "databricks_sku" {
    type = string
    description = "(Required) The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial. Changing this can force a new resource to be created in some circumstances."
}

variable "databricks_network_security_group_name" {
  type = string
}

variable "databricks_vnet_name" {
  type = string
}

variable "databricks_nat_gateway_public_ip_name" {
  type = string
  default = ""
}

variable "databricks_nat_gateway_name" {
  type = string
  default = ""
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

variable "ANSIBLE_EXECUTABLE_PATH" {
  type = string
}