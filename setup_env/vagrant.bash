#!/usr/bin/env bash

# Execute with sudo.
# Check required version at https://developer.hashicorp.com/vagrant/downloads

install_vagrant_linux() {
    
    if [ $(which apk) ]; then
        echo "Vagrant is not available on Alpine." && exit 1
        # apk update && apk add python3 py3-pynacl musl-dev gcc gcc-dev libffi-dev py3-cffi openssl-dev
    elif [ $(which apt) ]; then
        wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt update -y && sudo apt install -y vagrant
    elif [ $(which dnf) ]; then
        sudo dnf install -y dnf-plugins-core
        sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        sudo dnf -y install vagrant # needs version option.. TODO...
    else
        echo "NO PACKAGE MANAGER FOUND. (required for installing Vagrant.)" && exit 1
    fi
}


if [[ $1 == "" ]]; then
  echo "Requires an option: -v <Vagrant version>"
  exit 22
else
  while getopts "v:" option; do
    case ${option} in
      v )
        read -p "Vagrant version set to : [${OPTARG}] - [y/n] ? (Default: n): "
            REPLY=${REPLY:-n}

            if [ ${REPLY} == "n" ]; then
              echo "CANCELLED. BYE."
              exit 125
            elif [ ${REPLY} == "y" ]; then
              VERSION=${OPTARG}
            fi
            install_vagrant_linux
        ;;
      * )
          exit 22
        esac
    done
fi