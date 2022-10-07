/**
* Creates an Azure Storage Account.
*/

# --CAUTION

# UNCOMMENT THIS **ONLY IF YOU NEED TO IMPORT** THE FOLLOWING RESOURCES INTO THE STATE.
# OTHERWISE, IT IS INHERITED FROM THE PARENT MODULE/DEPLOYMENT.

# provider "azurerm" {
#     features {}
#     # subscription_id = var.client_subscription # USE WITH EXTRA *CAUTION - normally we switch the Subscription through az cli*.
#     skip_provider_registration = false
# }
# --CAUTION END

resource "azurerm_storage_account" "storage_account" {

    name = var.storage_account_name
    resource_group_name = var.storage_account_resource_group_name
    location = var.storage_account_location
    account_kind = var.storage_account_kind
    account_tier = var.storage_account_tier
    account_replication_type = var.storage_account_replication_type
    access_tier = var.storage_account_access_tier
    allow_blob_public_access = var.storage_account_blob_public_access
    shared_access_key_enabled = var.storage_account_shared_access_key
    is_hns_enabled = var.storage_account_hns
    nfsv3_enabled = var.storage_account_nfs
    network_rules {
      default_action = "Deny"
      ip_rules = var.storage_account_network_rules_ip_rules
      virtual_network_subnet_ids = toset(var.storage_account_network_rules_virtual_network_subnet_ids)
    }
    
    tags = merge(var.common_tags, var.client_tags)

    timeouts {
        create  = "5m"
        read    = "5m"
        update  = "5m"
        delete  = "5m"
    }
}

resource "azurerm_storage_container" "container" {

    for_each = var.storage_container
    name = each.key
    storage_account_name = azurerm_storage_account.storage_account.name
    container_access_type = var.storage_container_access_type

    timeouts {
        create  = "5m"
        read    = "5m"
        update  = "5m"
        delete  = "5m"
    }
}

# FINALLY, ADD A CHERRY TO THE PIE

resource "null_resource" "notify_slack" {

 provisioner "local-exec" {

   working_dir = "../../../ansible/notify_slack/plays" # EXTRA CARE - relative to this file . May not work in other files.
   command = "${var.ANSIBLE_EXECUTABLE_PATH}/ansible-playbook storage.yaml -e storage_account_name=${var.storage_account_name} -e storage_container=${var.storage_container} -e client_name=${lookup(var.client_tags, "ClientName")}"
 }
}