# STORAGE

variable "storage_account_name" {
    type = string
    description = "(Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
    validation {
        condition = can(regex("(?i:adls\\w)", var.storage_account_name))
        error_message = "Each Storage Datalake name must start with adls, and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "storage_account_resource_group_name" {
    type = string
    description = "Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
    validation {
        condition = can(regex("(?i:rg-\\w)", var.storage_account_resource_group_name))
        error_message = "Each Resource Group must start with rg-, include the desired Resource Type i.e. -databricks and end with -<CLIENT_NAME>. Case insensitive."
  }
}

variable "storage_account_location" {
    type = string
    description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "storage_account_kind" {
    type = string
    description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2."
}

variable "storage_account_tier" {
    type = string
    description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
}

variable "storage_account_replication_type" {
    type = string
    description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
}

variable "storage_account_access_tier" {
    type = string
    description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "storage_account_blob_public_access" {
    type = bool
    description = "Allow or disallow public access to all blobs or containers in the storage account. Defaults to false."
}

variable "storage_account_shared_access_key" {
    type = bool
    description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true."
}

variable "storage_account_hns" {
    type = bool
    description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created."
}

variable "storage_account_nfs" {
    type = bool
    description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false."
}

variable "storage_account_network_rules_default_action" {
    type = string
    description = "(Required) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
    default = "Deny"
}

variable "storage_account_network_rules_ip_rules" {
    type = set(string)
    description = "(Optional) List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed."
}

variable "storage_account_network_rules_virtual_network_subnet_ids" {
    type = set(string)
    description = "(Optional) A list of resource ids for subnets."
}

variable "storage_container" {
    type = set(string)
    description = "(Required) The name of the Container which should be created within the Storage Account."
}

variable "storage_container_account_name" {
    type = string
    description = "(Required) The name of the Storage Account where the Container should be created."
    default = ""
}

variable "storage_container_access_type" {
    type = string
    description = "(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
    default = "private"
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