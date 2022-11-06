#!/usr/bin/env bash

# Pre-requisites:
# 1. The user(s) already existing on the target system.
# 2. The domain name suffix is matching the actual host domain.
# 3. password.txt (or name it else) already contains a valid password common to these users.
# 4. The ssh-id already pre-configured for the given user(s) through ssh-keygen .

users=( ansible rancher )
hosts=( 
        tethys
        dev-k8s-master-1
)
domain_suffix="devanet"


for user in "${users[@]}" ;
  do
    for host in "${hosts[@].${domain_suffix}}" ;
      do sshpass -f password.txt ssh-copy-id -o StrictHostKeyChecking=no ${user}@${host} ;
    done
  done