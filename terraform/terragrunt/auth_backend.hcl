# NOTE: FILES LIKE THIS THAT CONTAIN CREDENTIALS, MUST BE FIRST ENCRYPTED WITH GIT-SECRET BEFORE BEING COMMITED TO GIT.

locals {
  backend_client_id = ""
  backend_client_secret = ""
  backend_subscription_id = ""
  backend_tenant_id = ""
  backend_resource_group_name = ""
  backend_storage_account_name = ""
  backend_container_name = "tfstate"
}


remote_state {
  disable_init = false
  backend = "azurerm"
  config = {
    subscription_id = local.backend_subscription_id
    tenant_id = local.backend_tenant_id
    client_id = local.backend_client_id
    client_secret = local.backend_client_secret
    resource_group_name = local.backend_resource_group_name
    storage_account_name = local.backend_storage_account_name
    container_name = local.backend_container_name
    key = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
}