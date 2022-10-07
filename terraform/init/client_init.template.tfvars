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

# AUTH

ARM_CLIENT_ID="" # adb-CLIENT_NAME-admin
ARM_CLIENT_SECRET=""
ARM_TENANT_ID=""
ARM_SUBSCRIPTION_ID="" # CLIENT_NAME subscription ID

# DATABRICKS WORKSPACE

#databricks_nat_gateway_public_ip_name = "databricks-nat-gw-pub-ip-CLIENT_NAME"
#databricks_nat_gateway_name = "databricks-nat-gw-CLIENT_NAME"
databricks_network_security_group_name = "databricks-nsg-CLIENT_NAME"
databricks_resource_group_name = "rg-databricks-CLIENT_NAME"
databricks_resource_group_azure_location = "westeurope"
databricks_resource_group_iam_contributors = [
  "", # DatabricksAdmins
]
databricks_resource_group_iam_readers = []
databricks_vnet_name = "vnet-databricks-CLIENT_NAME"
databricks_vnet_address_space = [
  "",
  ""
]
databricks_subnets =  {
  private = {
    cidr = "" # for new clients isolated in separate subscriptions, this is most usually 10.1.0.0/24 but always double check .
    service_delegation = "true"
    name  = "private"
  }
  public = {
    cidr = "" # for new clients isolated in separate subscriptions, this is most usually 10.2.0.0/24 but always double check.
    service_delegation = "true"
    name = "public"
  }   
}
databricks_workspace_name = "adb-CLIENT_NAME"
databricks_workspace_sku = "premium"

# DATABRICKS CLUSTER POOL

cluster_pools = {
  CLIENT_NAME-pool = {
    name = ""
    node_type_id = ""
    enable_elastic_disk = "true"
    availability = "ON_DEMAND_AZURE"
    idle_instance_autotermination_minutes = ""
    min_idle_instances = "0"
    max_capacity = ""
  }
}

# DATABRICKS CLUSTER

clusters = {
  CLIENT_NAME-cluster = {
    name = ""
    spark_version = ""
    driver_node_type_id = ""
    node_type_id = "" # mutually exclusive with instace_pool_id and viceversa.
    instace_pool_id = ""
    driver_instance_pool_id = ""
    policy_id = ""
    autotermination_minutes = ""
    enable_elastic_disk = "true"
    num_workers = ""
    cluster_log_conf = ""
    spark_conf = {
      ""="",
    }
    spark_env_vars = {
      ""="",
    }
  }
}

# DATABRICKS CLUSTER POLICY

policies = {
  general_purpose = {
  }
}


# DATABRICKS SECRET

secret_scopes = [
  "write",
  "read",
  "common",
]

secrets = {

  ### VARIOUS AZURE SERVICES

  metis-aad-auth-endpoint = {
    scope = "common"
    value = ""
  }

  datalake-url = {
    scope = "common"
    value = "abfss://datalake@adlsCLIENT_NAME.dfs.core.windows.net/"
  }
  
  adb-CLIENT_NAME-user-client-id = {
    scope = "read"
    value = ""
  }

  adb-CLIENT_NAME-user-client-secret = {
    scope = "read"
    value = ""
  }
  
  adb-CLIENT_NAME-contributor-client-id = {
    scope = "write"
    value = ""
  }

  adb-CLIENT_NAME-contributor-client-secret = {
    scope = "write"
    value = ""
  }
}

# DATABRICKS LIBRARY

# DATABRICKS SQL ENDPOINT

# DATABRICKS DBFS MOUNT


# STORAGE GLOBAL

# add public static ips of client and of our HQ
storage_account_network_rules_ip_rules = [] 
storage_account_network_rules_default_action = "Deny"
storage_account_resource_group_iam_contributors = []
storage_account_resource_group_iam_readers = [
  "", # DatabricksAdmins
  "", # rg-CLIENT_NAME-users
  "", # adb-CLIENT_NAME-user
]
storage_account_resource_group_iam_storage_blob_data_readers = [
  "", # DatabricksAdmins
  "", # rg-CLIENT_NAME-users
  "", # adb-CLIENT_NAME-user
]
storage_account_resource_group_iam_storage_blob_data_contributors = [
  "", # adb-admin
  "", # adb-CLIENT_NAME-contributor
]
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

storage_account_datalake_container = ["datalake"]
storage_account_datalake_container_access_type = "private"

## KIND: FILESHARE