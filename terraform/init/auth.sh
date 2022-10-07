#!/bin/bash

# Exit immediately if a command fails. Deactivating this option will output massive and unnecesarry error stacktraces. Keep it clean with this option!
set -e

source env.sh

# here, if not already logged-in with Azure CLI, this script exits with error code 1, due to the above setting "set -e".

echo -e "\n- CHECK - Existing Azure Authentication\n----------------------"

az_account=$(az account show)

# Grab user_type and user_name to do pre-flight check of user permissions on the Azure Tenant level.
# Initially, a Global Admin or Owner is required.

_python="$(command -v python)"

subscription_name=$(echo "${az_account}" | ${_python} -c 'import sys,json; print(json.load(sys.stdin)["name"])')
subscription_id=$(echo "${az_account}" | ${_python} -c 'import sys,json; print(json.load(sys.stdin)["id"])')
user_type=$(echo "${az_account}" | ${_python} -c 'import sys,json; print(json.load(sys.stdin)["user"]["type"])')
user_name=$(echo "${az_account}" | ${_python} -c 'import sys,json; print(json.load(sys.stdin)["user"]["name"])')
# [ -z "${user_type}" ] || [ -z "${user_name}" ] && exit 1
if [ "${user_type}" == "servicePrincipal" ]; then
    echo -e "- ERROR - Authenticating using the Azure CLI is only supported as a User (not a Service Principal)."
    echo -e "Please first run 'az login' with a directory administrator User Principal."
    exit 1
else
    echo -e "- OK - Will use the current Azure CLI login (\"${user_name}\") to authenticate to Azure RM.\n----------------------"
fi

# Show current account login status - current Subscription name & id.

echo -e "- OK - Current Subscription : $subscription_name - ID: $subscription_id\n----------------------"

# Set necessary Subscription

echo -e "- OK - Setting the Subscription to : $ARM_SUBSCRIPTION_ID - ($ARM_SUBSCRIPTION_NAME)\n"

az account set --subscription ${ARM_SUBSCRIPTION_ID}
echo ${az_account}

echo -e "- OK - Current Subscription : $subscription_name - ID: $subscription_id\n----------------------"

echo -e "\n"
