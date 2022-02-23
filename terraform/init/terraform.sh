#!/bin/bash

# Runs all Terraform commands.
# Runs after 1) client_init.sh , 2) the manual addition of values in <client_name>.tfvars has been done.

# Exit immediately if a command fails. Deactivating this option will output massive and unnecesarry error stacktraces. Keep it clean with this option!
# set -e
# ^ here we don't need it globally because we need to grab the exit code itself of a function.

source auth.sh

# truncate the tf log to start clean
truncate -s 0 $TF_LOG_PATH


file_check_client() {

    # if client file exists and has content...returns the default codes exit codes (true:0), otherwise (false:1)

    [ -s ${CLIENTS_PATH}/${CLIENT_NAME}."tfvars" ]
}

file_check_deployment() {

    # if deployment file exists and has content...returns the default codes exit codes (true:0), otherwise (false:1)

    [ -s ${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME}/${DEPLOYMENT_NAME}."tf" ]
}

terraform_init() {
    set -e

    # $TERRAFORM_EXECUTABLE_PATH/terraform -chdir=${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME} workspace new ${CLIENT_NAME} # add check if exists.
    $TERRAFORM_EXECUTABLE_PATH/terraform -chdir=${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME} init
}

terraform_plan() {
    set -e

    # This creates and outputs a plan/confirmation of what is going to be deployed/applied when the "apply" command is ran.
    # Can also export the plan to a file for inspection and also as input to the "apply" command.

    if [ $# -eq 2 ]; then
        $TERRAFORM_EXECUTABLE_PATH/terraform -chdir=${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME} workspace select ${CLIENT_NAME}
        $TERRAFORM_EXECUTABLE_PATH/terraform -chdir=${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME} plan -var-file=${CLIENTS_PATH}/${CLIENT_NAME}.tfvars -out=${PLANS_PATH}/plan-${CLIENT_NAME}-${DEPLOYMENT_NAME} -compact-warnings
    else
        echo "Wrong number of arguments."
        exit 1
    fi
}

terraform_plan_to_target() {
    set -e

    # This creates and outputs a plan/confirmation of what is going to be deployed/applied when the "apply" command is ran.
    # Targeting specific module/resource.
    # Can also export the plan to a file for inspection and also as input to the "apply" command.

    if [ $# -eq 3 ]; then
        $TERRAFORM_EXECUTABLE_PATH/terraform -chdir=${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME} plan -var-file=${CLIENTS_PATH}/${CLIENT_NAME}.tfvars -out=${PLANS_PATH}/plan-target-${CLIENT_NAME}-${DEPLOYMENT_NAME} -compact-warnings -target="${TARGET_NAME}"
    else
        echo "Wrong number of arguments."
        exit 1
    fi
}

terraform_plan_to_destroy() {
    set -e

    # This creates and outputs a plan/confirmation of what is going to be deployed/applied when the "apply" command is ran.
    # When the -destroy option is enabled .
    # Can also export the plan to a file for inspection and also as input to the "apply" command.

    if [ $# -eq 3 ]; then
        $TERRAFORM_EXECUTABLE_PATH/terraform -chdir=${DEPLOYMENTS_PATH}/${DEPLOYMENT_NAME} plan -var-file=${CLIENTS_PATH}/${CLIENT_NAME}.tfvars -out=${PLANS_PATH}/plan-destroy-${CLIENT_NAME}-${DEPLOYMENT_NAME} -compact-warnings -destroy
    else
        echo "Wrong number of arguments."
        exit 1
    fi
}

if [[ $1 == "" ]]; then
    echo "- ERROR - Requires options: -c <CLIENT_NAME> -d <DEPLOYMENT_NAME> [-t <'name.reference_name'> ] [-X]"
    exit 1
else
    while getopts "c:d:t:X" option; do
        case ${option} in
        c ) # "c" for "c-lient"
            read -p "Client has been set to : ${OPTARG} - [Y/N] ? [Default: N]: "
                REPLY=${REPLY:-N}
                CLIENT_NAME=${OPTARG}

                if [ ${REPLY} == "N" ]; then
                    echo "CANCELLED."
                    exit 1
                elif [ ${REPLY} == "Y" ]; then
                    file_check_client ${CLIENT_NAME}
                    file_check_client_status=$?
                    if [[ file_check_client_status -eq 1 ]]; then
                        echo "- ERROR - Client file NOT FOUND.\n"
                        exit 1
                    else
                        echo -e "- OK - Client file FOUND."
                    fi
                elif [ ${REPLY} != "Y" ] || [ ${REPLY} != "N" ]; then
                    echo "Wrong option. You must type Y or N."
                    exit 1
                fi
            ;;
        d ) # "d" for "d-eployment"
            read -p "Deployment has been set to : ${OPTARG} - [Y/N] ? [Default: N]: "
                REPLY=${REPLY:-N}
                DEPLOYMENT_NAME=${OPTARG}

                if [ ${REPLY} == "N" ]; then
                    echo "CANCELLED."
                    exit 1
                elif [ ${REPLY} == "Y" ]; then
                    file_check_deployment ${DEPLOYMENT_NAME}
                    file_check_deployment_status=$?
                    if [[ file_check_deployment_status -eq 1 ]]; then
                        echo -e "- ERROR - Deployment file NOT FOUND.\n"
                        exit 1
                    else
                        echo -e "- OK - Deployment file FOUND.\n"
                        echo -e "- OK - Preparing to build [${DEPLOYMENT_NAME}] for client [${CLIENT_NAME}]\n"
                        terraform_init ${DEPLOYMENT_NAME}
                        terraform_plan ${CLIENT_NAME} ${DEPLOYMENT_NAME}
                    fi
                elif [ ${REPLY} != "Y" ] || [ ${REPLY} != "N" ]; then
                    echo "Wrong option. You must type Y or N."
                    exit 1
                fi
            ;;
        t ) # "t" for "t-arget"
            read -p "Target has been set to : ${OPTARG} - [Y/N] ? [Default: N]: "
                REPLY=${REPLY:-N}
                TARGET_NAME=${OPTARG}

                if [ ${REPLY} == "N" ]; then
                    echo "CANCELLED."
                    exit 1
                elif [ ${REPLY} == "Y" ]; then
                    echo -e "- OK - Preparing to build target [${TARGET_NAME}] from [${DEPLOYMENT_NAME}] for client [${CLIENT_NAME}]\n"
                    terraform_init
                    terraform_plan_to_target ${CLIENT_NAME} ${DEPLOYMENT_NAME} ${TARGET_NAME}
                elif [ ${REPLY} != "Y" ] || [ ${REPLY} != "N" ]; then
                    echo "Wrong option. You must type Y or N."
                    exit 1
                fi
            ;;
        X )
            read -p "CAUTION! This will DESTROY the specified resource [${DEPLOYMENT_NAME}] for client [${CLIENT_NAME}]! Are you ABSOLUTELY sure?” YES-DESTROY/N [default: N]: "
                REPLY=${REPLY:-N}

                if [ ${REPLY} == "N" ]; then
                    echo "CANCELLED."
                    exit 1
                elif [ ${REPLY} == "YES-DESTROY" ]; then
                    echo -e "- OK - Preparing to DESTROY [${DEPLOYMENT_NAME}] for client [${CLIENT_NAME}]\n"
                    # terraform_validate # set aside for now
                    # terraform_init ${DEPLOYMENT_NAME}
                    terraform_plan_to_destroy ${CLIENT_NAME} ${DEPLOYMENT_NAME}
                elif [ ${REPLY} != "YES-DESTROY" ] || [ ${REPLY} != "N" ]; then
                    echo "Wrong option. You must type YES-DESTROY or N."
                    exit 1
                fi
            ;;
        * )
            exit 1
        esac
    done
fi
