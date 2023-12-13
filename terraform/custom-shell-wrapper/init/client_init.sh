#!/usr/bin/env bash

# USAGE: ./client_init.sh -c <CLIENT_NAME>
# Accepts user input parameter with -c
# its value is used to create the client Terraform variables file (<client_name>.tfvars)
# and to modify the CLIENT_NAME placeholder in some of this file's values.
# Some values, e.g. of the Databricks network ranges, MUST be specified by hand inside (<client_name>.tfvars).
# (The reason 'getopts' is used and 'getopt' has not been used is portability and safety.)
# NOTE: In this file, do not use "set -e", because it will fail from the functions.
# RTFM: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html#Bash-Conditional-Expressions

source env.sh

file_check_client() {

    # if client file exists and has content...returns the default codes exit codes (true:0), otherwise (false:1)

    [ -s ${CLIENTS_PATH}/${CLIENT_NAME}."tfvars" ]
}

set_client() {

    if [ $# -eq 1 ] ; then
        echo "Updating -> $CLIENTS_PATH/$CLIENT_NAME.tfvars"
        cp ./client_init.template.tfvars $CLIENTS_PATH/$CLIENT_NAME.tfvars
        # IF IN MACOS : sed -i '' -e s/CLIENT_NAME/$CLIENT_NAME/g $CLIENTS_PATH/$CLIENT_NAME.tfvars
        sed -i s/CLIENT_NAME/$CLIENT_NAME/g $CLIENTS_PATH/$CLIENT_NAME.tfvars
        echo "Done. Now you can edit $CLIENTS_PATH/$CLIENT_NAME.tfvars accordingly (if any are required), and then run ./terraform.sh. Bye!"
    else
        echo "Wrong number of arguments."
    fi
}

if [[ $1 == "" ]]; then
    echo "Requires an option: -c <client_name>"
    exit 1
else
    while getopts "c:" option; do
        case ${option} in
        c )
            read -p "Client has been set to : [${OPTARG}] - [Y/N] ? [Default: N]: "
                REPLY=${REPLY:-N}
                CLIENT_NAME=${OPTARG}

                if [ ${REPLY} == "N" ]; then
                    echo "CANCELLED."
                    exit 1
                elif [ ${REPLY} == "Y" ]; then
                    file_check_client ${CLIENT_NAME}
                    file_check_client_status=$?
                    if [[ file_check_client_status -eq 0 ]]; then
                        echo "Client [${CLIENT_NAME}] already exists. Exiting."
                        exit 1
                    else
                        echo "Initializing variables for new client: [${OPTARG}]"
                        set_client ${CLIENT_NAME}
                    fi
                elif [ ${REPLY} != "Y" ] || [ ${REPLY} != "N" ]; then
                    echo "Wrong option. You must type Y or N."
                    exit 1

                fi
            ;;
        * )
            exit 1
        esac
    done
fi
