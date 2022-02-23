# NOTES:
# This is just a template that is copied over for a new client under clients/client_X.tfvars
# DO *NOT* ADD CLIENT_X VALUES HERE.

# COMMONLY USED VARIABLES

common_tags = { 
  ManagedBy = "DevOps Team with Terraform"
}

client_tags = { 
  Client = "yes"
  ClientName = "unipi"
}

ANSIBLE_EXECUTABLE_PATH = "/usr/local/bin"

# SUBSCRIPTION

# SERVICE PRINCIPAL

# DATABRICKS

#databricks_nat_gateway_public_ip_name = "databricks-nat-gw-pub-ip-unipi"
#databricks_nat_gateway_name = "databricks-nat-gw-unipi"
databricks_network_security_group_name = "databricks-nsg-unipi"
databricks_resource_group_name = "rg-databricks-unipi"
databricks_resource_group_azure_location = "westeurope"
databricks_resource_group_iam_contributors = [
  "f81eb762-16dc-4a37-ab75-73a8d83ea4d4", 
  "d0eba2a5-c259-4725-9d3f-6e6f5af59385"
]
databricks_resource_group_iam_readers = ["bb49fde6-d0c1-4b14-bbdb-bde8cfc1a0a3"]
databricks_vnet_name = "vnet-databricks-unipi"
databricks_vnet_address_space = ["10.11.0.0/24", "10.12.0.0/24"]
databricks_subnets =  {
  private = {
            cidr = "10.11.0.0/24"
            service_delegation = "true"
            name  = "private"
  }
  public = {
            cidr = "10.12.0.0/24"
            service_delegation = "true"
            name = "public"
  }   
}
databricks_workspace_name = "adb-unipi"
databricks_workspace_sku = "premium"


# STORAGE GLOBAL
storage_account_network_rules_ip_rules = [
  "62.74.235.162",
]
storage_account_network_rules_default_action = "Deny"
storage_account_resource_group_iam_contributors = []
storage_account_resource_group_iam_readers = [
  "bb49fde6-d0c1-4b14-bbdb-bde8cfc1a0a3",
  "f81eb762-16dc-4a37-ab75-73a8d83ea4d4"
]
storage_account_resource_group_iam_storage_blob_data_readers = [
  "bb49fde6-d0c1-4b14-bbdb-bde8cfc1a0a3",
  "f81eb762-16dc-4a37-ab75-73a8d83ea4d4",
  "6e6b1539-656b-40b4-a974-c48d7b626dd6", # adb-unipi-user
]
storage_account_resource_group_iam_storage_blob_data_contributors = [
  "00abc9ad-d648-443c-bae3-b71782d6ba89" # adb-unipi-contributor
]

## KIND: DATALAKE
storage_account_datalake_name = "adlsunipi"
storage_account_datalake_resource_group_name = "rg-storage-unipi"
storage_account_datalake_location = "westeurope"
storage_account_datalake_kind = "StorageV2"
storage_account_datalake_account_tier = "Standard"
storage_account_datalake_replication_type = "LRS"
storage_account_datalake_access_tier = "Hot"
storage_account_datalake_blob_public_access = false
storage_account_datalake_shared_access_key = true
storage_account_datalake_hns = true
storage_account_datalake_nfs = false

## CONTAINERS

storage_account_datalake_container = ["datalake"]
storage_account_datalake_container_access_type = "private"

## KIND: FILESHARE