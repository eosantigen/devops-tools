/**
* Manage Clusters within a Databricks Workspace.
*/


data "databricks_spark_version" "latest_lts" {
  latest = true
  long_term_support = true
}

resource "databricks_cluster" "cluster" {
  
}



# FINALLY, ADD A CHERRY TO THE PIE

resource "null_resource" "notify_slack" {

 provisioner "local-exec" {

   working_dir = "../../../ansible/notify_slack/plays" # EXTRA CARE - relative to this file . May not work in other files.
   command = "${var.ANSIBLE_EXECUTABLE_PATH}/ansible-playbook databricks_cluster.yaml -e cluster_pools=${var.cluster_pools} -e databricks_workspace_name=${var.databricks_workspace_name} -e client_name=${lookup(var.client_tags, "ClientName")}"
 }
}