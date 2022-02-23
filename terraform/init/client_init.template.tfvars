# NOTES:
# This is just a template that is copied over for a new client under clients/client_X.tfvars
# DO *NOT* ADD CLIENT_X VALUES HERE.

# COMMONLY USED VARIABLES

common_tags = { 
  ManagedBy = "DevOps Team with Terraform"
}

client_tags = { 
  Client = "yes"
  ClientName = "CLIENT_NAME"
}

ANSIBLE_EXECUTABLE_PATH = "/usr/local/bin"

# SUBSCRIPTION

# SERVICE PRINCIPAL

# DATABRICKS

#databricks_nat_gateway_public_ip_name = "databricks-nat-gw-pub-ip-CLIENT_NAME"
#databricks_nat_gateway_name = "databricks-nat-gw-CLIENT_NAME"
databricks_network_security_group_name = "databricks-nsg-CLIENT_NAME"
databricks_resource_group_name = "rg-databricks-CLIENT_NAME"
databricks_resource_group_azure_location = "westeurope"
databricks_resource_group_iam_contributors = ["f81eb762-16dc-4a37-ab75-73a8d83ea4d4"]
databricks_resource_group_iam_readers = [""]
databricks_vnet_name = "vnet-databricks-CLIENT_NAME"
databricks_vnet_address_space = ["", ""]
databricks_subnets =  {
  private = {
            cidr = ""
            service_delegation = "true"
            name  = "private"
  }
  public = {
            cidr = ""
            service_delegation = "true"
            name = "public"
  }   
}
databricks_workspace_name = "adb-CLIENT_NAME"
databricks_workspace_sku = "premium"


# STORAGE GLOBAL
storage_account_network_rules_ip_rules = ["62.74.235.162"] # add public static ips of client and of our HQ
storage_account_network_rules_default_action = "Deny"
storage_account_resource_group_iam_contributors = []
storage_account_resource_group_iam_readers = ["", "f81eb762-16dc-4a37-ab75-73a8d83ea4d4"]
storage_account_resource_group_iam_storage_blob_data_readers = ["", "f81eb762-16dc-4a37-ab75-73a8d83ea4d4"]
storage_account_resource_group_iam_storage_blob_data_contributors = []

## KIND: DATALAKE
storage_account_datalake_name = "adlsCLIENT_NAME"
storage_account_datalake_resource_group_name = "rg-storage-CLIENT_NAME"
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

storage_account_datalake_container = "datalake"
storage_account_datalake_container_access_type = "private"

## KIND: FILESHARE