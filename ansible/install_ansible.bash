#!/bin/bash


ANSIBLE_VERSION="2.9.9"


if [ -x /sbin/apk ]; then
    apk update && apk add py3-pynacl musl-dev gcc gcc-dev libffi-dev py3-cffi openssl-dev python3

elif [ -x /usr/bin/apt ]; then
    apt install -y python3 python3-pip openssl-dev python3-cffi libffi-dev #.......TODO : Check packages.

elif [ -x /usr/bin/dnf || /usr/bin/yum ]; then
    # check updated commanline for this distro.
    echo "NEEDS FIXING";
fi

echo "NO PACKAGE MANAGER FOUND.\n(required for installing Ansible dependencies.)" && exit 1;

#python3 -m pip install ansible=${ANSIBLE_VERSION}
