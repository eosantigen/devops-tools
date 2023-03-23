#!/usr/bin/env bash

# Execute with sudo.
# sudo ./install_ansible.bash -v 7.0.0 -u $USER
# and then, optionally, either open a new terminal tab or do:
# su -l $USER
# If the username is meant to be another username in your system, instead of $USER provide their username, ( _in lowercase and without the $_ )

# Check required version at https://pypi.org/project/ansible/

install_ansible_linux() {
    
    if [ $(which apk) ]; then
        apk update && apk add python3 py3-pynacl musl-dev gcc gcc-dev libffi-dev py3-cffi openssl-dev
    elif [ $(which apt) ]; then
        apt update -y && apt install -y python3 libssl-dev python3-cffi libffi-dev
    elif [ $(which dnf) ]; then
        dnf check-update && dnf --best install python3
    else
        echo "NO PACKAGE MANAGER FOUND. (required for installing Ansible dependencies.)"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then sudo -u ${USER} python3 -m pip install --user ansible==${VERSION};
    else echo "An error occured with the package manager, cannot proceed with installation."
    fi
}


if [[ $1 == "" ]]; then
  echo "Requires 2 options: -v <Ansible version> -u <username>"
  exit 22
else
  while getopts "v:u:" option; do
    case ${option} in
      v )
        read -p "Ansible version set to : [${OPTARG}] - [y/n] ? (Default: n): "
            REPLY=${REPLY:-n}

            if [ ${REPLY} == "n" ]; then
              echo "CANCELLED. BYE."
              exit 125
            elif [ ${REPLY} == "y" ]; then
              VERSION=${OPTARG}
            fi
        ;;
      u )
        read -p "Installing for user: [${OPTARG}] - [y/n] ? (Default: n): "
            REPLY=${REPLY:-n}
        
            if [ ${REPLY} == "n" ]; then
              echo "CANCELLED. BYE."
              exit 125
            elif [ ${REPLY} == "y" ]; then
              USER=${OPTARG}
            fi
            install_ansible_linux
        ;;
      * )
          exit 22
        esac
    done
fi