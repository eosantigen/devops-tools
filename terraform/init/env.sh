#!/usr/bin/env bash

# NOTES:
# Avoid the trailing slashes on paths here and place them in the commands instead.

# GENERAL
export ANSIBLE_PIP_VERSION="2.9.9"

# PATHS

export BASE_PATH="$HOME/devops-tools/terraform"
export TERRAFORM_EXECUTABLE_PATH="/usr/local/bin"
export PLANS_PATH="/tmp"
export CLIENTS_PATH="$BASE_PATH/azure/clients"
export DEPLOYMENTS_PATH="$BASE_PATH/azure/deployments"
export ANSIBLE_EXECUTABLE_PATH="/usr/local/bin"
export ANSIBLE_PLAYS_PATH="$BASE_PATH/ansible/plays"

# ARM (Azure Resource Manager)
# export ARM_SUBSCRIPTION_NAME="" # OBSOLETE - Subscription set elsewhere with its ID.
export ARM_DISABLE_TERRAFORM_PARTNER_ID="true"

# TF_ RESERVED - tf settings
export TF_LOG_PATH="/tmp/terraform.log"
export TF_LOG="debug" # excellent for debugging the cli