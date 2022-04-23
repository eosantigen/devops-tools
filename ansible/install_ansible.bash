#!/bin/bash


ANSIBLE_VERSION="2.9.9"


if [ -x /sbin/apk ]; then
    apk update && apk add py3-pynacl musl-dev gcc gcc-dev libffi-dev py3-cffi openssl-dev python3

elif [ -x /usr/bin/apt ]; then
    apt install -y python3-pip libssl-dev python3-cffi libffi-dev
else
    echo "NO PACKAGE MANAGER FOUND.\n(required for installing Ansible dependencies.)" && exit 1;
fi
python3 -m pip install ansible==${ANSIBLE_VERSION}
