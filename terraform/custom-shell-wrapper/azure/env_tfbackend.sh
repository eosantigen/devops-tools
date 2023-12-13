#!/usr/bin/env bash

# GLOBAL - SYSTEM-WIDE

export TFBACKEND__USE_MICROSOFT_GRAPH=true
export TFBACKEND__SUBSCRIPTION_ID=""
export TFBACKEND__TENANT_ID=""
export TFBACKEND__CLIENT_ID="" # ADD IT HERE BEFORE EXECUTION . (SP: app-devops)
export TFBACKEND__CLIENT_SECRET="" # ADD IT HERE BEFORE EXECUTION .
export TFBACKEND__RESOURCE_GROUP_NAME=""
export TFBACKEND__STORAGE_ACCOUNT_NAME=""
export TFBACKEND__CONTAINER_NAME=""
# export TFBACKEND__KEY="${DEPLOYMENT_NAME}" - DO NOT USE HERE - exported through the terraform_init() function dynamically for each deployment (root module).


export TF_CLI_ARGS_init="\
  -backend-config="use_microsoft_graph=${TFBACKEND__USE_MICROSOFT_GRAPH}" \
  -backend-config="subscription_id=${TFBACKEND__SUBSCRIPTION_ID}" \
  -backend-config="tenant_id=${TFBACKEND__TENANT_ID}" \
  -backend-config="client_id=${TFBACKEND__CLIENT_ID}" \
  -backend-config="client_secret=${TFBACKEND__CLIENT_SECRET}" \
  -backend-config="resource_group_name=${TFBACKEND__RESOURCE_GROUP_NAME}" \
  -backend-config="storage_account_name=${TFBACKEND__STORAGE_ACCOUNT_NAME}" \
  -backend-config="container_name=${TFBACKEND__CONTAINER_NAME}" \
  -backend-config="key=${TFBACKEND__KEY}" \
  "