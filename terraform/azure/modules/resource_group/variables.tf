# RESOURCE GROUP

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group."
  validation {
    condition = can(regex("(?i:rg-\\w)", var.resource_group_name))
    error_message = "Each Resource Group must start with rg-, include the desired Resource Type i.e. -storage and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "resource_group_azure_location" {
  type        = string
  description = "Azure location for the Resource Group."
  default     = "westeurope"
}

# RESOURCE GROUP IAM

variable "resource_group_iam_owners" {
  type        = list(string)
  description = "(Optional) A list of Object IDs that should have the Owner role over the Resource."
  default     = []
}

variable "resource_group_iam_contributors" {
  type        = list(string)
  description = "(Optional) A list of Object IDs that should have the Contributor role over the Resource Group."
  default     = []
}

variable "resource_group_iam_readers" {
  type        = list(string)
  description = "(Optional) A list of Object IDs that should have the Reader role over the Resource Group."
  default     = []
}

# RESOURCE GROUP IAM - STORAGE

variable "resource_group_iam_storage_blob_data_contributors" {
  type        = list(string)
  description = "(Optional) A list of Object IDs that should have the Storage Blob Data Contributor role over the Resource Group."
  default     = []
}

variable "resource_group_iam_storage_blob_data_readers" {
  type        = list(string)
  description = "(Optional) A list of Object IDs that should have the Storage Blob Data Reader role over the Resource Group."
  default     = []
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