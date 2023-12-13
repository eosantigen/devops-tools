# NOTE: FILES LIKE THIS THAT CONTAIN CREDENTIALS, MUST BE FIRST ENCRYPTED WITH GIT-SECRET BEFORE BEING COMMITED TO GIT.

locals {
  provider_client_id = ""
  provider_client_secret = ""
  provider_subscription_id = ""
  provider_tenant_id = ""
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
  
    provider "azurerm" {
      features {}
      skip_provider_registration = false
      client_id = "${local.provider_client_id}"
      client_secret = "${local.provider_client_secret}"
      subscription_id = "${local.provider_subscription_id}"
      tenant_id = "${local.provider_tenant_id}"
    }
  EOF
}