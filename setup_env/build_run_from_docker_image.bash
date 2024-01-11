#!/usr/bin/env bash

###### DOCS ######

# https://www.cyberciti.biz/faq/linux-bash-exit-status-set-exit-statusin-bash/ - Exit codes
# https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html#Bash-Conditional-Expressions - Conditional Expressions
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html - the Set built-in option to tune the commandline for this executable file.

###### SHELL TUNING OPTIONS ######

set -e

###### ENVIRONMENT VARIABLES ######

PATH_TO_MAIN_DOCKERFILE="../../Dockerfile" # relative path
PATH_TO_TEST_DOCKERFILE="./Dockerfile" # relative to the build.bash this file.
PATH_TO_COMPOSE_YAML="./compose.yaml"
PROJECT_NAME=`basename -s 'git@github.com:eosantigen/' -s '.git' $(git remote get-url origin --all)`

###### FUNCTIONS ######

set_dockerfile_from() {

  if [ $# -eq 1 ]; then

    if [[ -s ${PATH_TO_MAIN_DOCKERFILE} ]]; then

      cp ${PATH_TO_MAIN_DOCKERFILE} ${PATH_TO_TEST_DOCKERFILE} 
      sed -i -e "s#{BASE_IMAGE}#${BASE_IMAGE}#g" ${PATH_TO_TEST_DOCKERFILE} 
    else
      echo -e "PATH_TO_MAIN_DOCKERFILE MAY NOT EXIST.\n"
      exit 2 # 2 means "no such file or directory"
    fi
  else
      echo "Wrong number of arguments."
      exit 22 # 22 means "invalid argument"
  fi
}

set_project_name(){

  if [[ -s ${PATH_TO_MAIN_DOCKERFILE} ]] && [[ -s ${PATH_TO_COMPOSE_YAML} ]]; then
    sed -i -e "s#{PROJECT_NAME}/${PROJECT_NAME}#g" ${PATH_TO_COMPOSE_YAML} 
  else
    echo -e "PATH_TO_MAIN_DOCKERFILE and PATH_TO_COMPOSE_YAML MAY NOT EXIST.\n"
    exit 2 # 2 means "no such file or directory"
  fi
}

docker_compose_up() {

  docker-compose up || echo -e "Failed to run Docker Compose. Check the compose.yaml. \n"
}

###### SCRIPT PARAMETERS/OPTIONS/ENTRYPOINT ######

if [[ $1 == "" ]]; then
  echo "Requires the switch: -b"
  exit 22
else
  while getopts "b:" option; do
      case ${option} in
          b )
          read -p "Base image to build FROM for this app : [${OPTARG}] - [y/n] ? [Default: n]: "
              REPLY=${REPLY:-n}

              if [ ${REPLY} == "n" ]; then
                echo "CANCELLED."
                exit 125
              elif [ ${REPLY} == "y" ]; then
                echo -e "Base image to build FROM will be set to : ${OPTARG} \n"
                BASE_IMAGE=${OPTARG}
                set_dockerfile_from $BASE_IMAGE
                set_project_name
                echo -e "Dockerfile and Docker Compose file is set. Pausing for 1'..."
                sleep 1m
                docker_compose_up
              fi
            ;;
          * )
            exit 22
      esac
  done
fi