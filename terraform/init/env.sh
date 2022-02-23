#!/bin/bash

# NOTES:
# Avoid the trailing slashes on paths here and place them in the commands instead.

# GENERAL
export ANSIBLE_PIP_VERSION="2.9.9"

# PATHS
export TERRAFORM_EXECUTABLE_PATH="/usr/local/bin"
export PLANS_PATH="/tmp"
export CLIENTS_PATH="$HOME/METIS/devops-tools/terraform/azure/clients"
export DEPLOYMENTS_PATH="$HOME/METIS/devops-tools/terraform/azure/deployments"
export MODULES_PATH="$HOME/METIS/devops-tools/terraform/azure/modules"
export ANSIBLE_EXECUTABLE_PATH="/usr/local/bin"
export ANSIBLE_PLAYS_PATH="$HOME/METIS/devops-tools/terraform/ansible/plays"

# ARM (Azure Resource Manager)
export ARM_SUBSCRIPTION_ID="89a5878b-7d89-497c-9e4c-1bc68a9ca268" # Research Subscription - how is this gonna change dynamically?
export ARM_SUBSCRIPTION_NAME="Research Subscription"
export ARM_DISABLE_TERRAFORM_PARTNER_ID="true"

# TF_ RESERVED - tf settings
export TF_LOG_PATH="/tmp/terraform.log"
export TF_LOG="debug" # excellent for debugging the cli