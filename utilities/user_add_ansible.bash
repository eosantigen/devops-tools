#!/usr/bin/env bash

# Creates ansible user on respective hosts we want to manage.
# Use this on a set of hosts where you want to have a user for Ansible to execute tasks on there. 
# To be executed from your local control node or where Ansible is executed the most which acts as a control node .
# (it's a good practice to have a dedicated separate user for such configuration management tools. Never use root for the ansible's executions, please.)
# The path to the key "ansible.pub" must exist or fix it accordingly.
# Do not worry if some errors occur, like "group not fonund" - it's safe .
# Tethys doesn't necessarily mean it's going to be used as a control node, but it could.


user="ansible"
user_groups=( docker )
managed_nodes__rancheros=(
  dev-k8s-master-0
  dev-k8s-master-1
  dev-k8s-master-2
)
control_nodes=(
  tethys
  jenkins
)
hosts_domain_suffix="devanet"

IFS=,

################## MANAGED NODE ##################
for managed_node__rancheros in "${managed_nodes__rancheros[@]}" ;
do
  # Create user, through the root user for which we already have access (added its key through our ssh-agent...)
  ssh rancher@${managed_node__rancheros}.${hosts_domain_suffix} sudo adduser -G ${user} ${user} ;
  ssh rancher@${managed_node__rancheros}.${hosts_domain_suffix} sudo addgroup ${user} ${user_groups[*]} ;

  sshpass -p${user} ssh-copy-id -i $HOME/keys/ansible.pub -o StrictHostKeyChecking=no ${user}@${managed_node__rancheros}.${hosts_domain_suffix} ;
done
################## CONTROL NODE ##################
for control_node in "${control_nodes[@]}" ;
do
  ssh root@${control_node}.${hosts_domain_suffix} useradd --create-home --shell bash --groups ${user_groups[*]} ${user};
  # In case the previous fails on Linux , try this on BSD...
  ssh root@${control_node}.${hosts_domain_suffix} pw useradd ${user} -w yes -s bash -G ${user_groups[*]} ;
  ssh root@${control_node}.${hosts_domain_suffix} pw useradd ${user} -w yes -s bash ;
  # Copy ONLY the "ansible" key pair
  sshpass -p${user} ssh-copy-id -i $HOME/keys/ansible.pub -o StrictHostKeyChecking=no ${user}@${control_node}.${hosts_domain_suffix} ;
done