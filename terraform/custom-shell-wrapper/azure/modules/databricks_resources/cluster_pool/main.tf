/**
* Manage Cluster Pools within a Databricks Workspace.
*/


resource "databricks_instance_pool" "instance_pool" {
  for_each = var.cluster_pools

  instance_pool_name = each.key
  node_type_id = each.value.node_type_id
  enable_elastic_disk = each.value.enable_elastic_disk
  idle_instance_autotermination_minutes = each.value.idle_instance_autotermination_minutes
  max_capacity = each.value.max_capacity
  min_idle_instances = each.value.min_idle_instances
  azure_attributes {
    availability = each.value.availability
  }
  custom_tags = merge(var.common_tags, var.client_tags)
}


# FINALLY, ADD A CHERRY TO THE PIE

resource "null_resource" "notify_slack" {

 provisioner "local-exec" {

   working_dir = "../../../ansible/notify_slack/plays" # EXTRA CARE - relative to this file . May not work in other files.
   command = "${var.ANSIBLE_EXECUTABLE_PATH}/ansible-playbook databricks_cluster_pool.yaml -e cluster_pools=${var.cluster_pools} -e databricks_workspace_name=${var.databricks_workspace_name} -e client_name=${lookup(var.client_tags, "ClientName")}"
 }
}