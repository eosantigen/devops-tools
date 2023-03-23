# Introduction

This bundle assumes a VM (probably with VirtualBox) of Ubuntu 22.04 LTS (ideally!). _Not supported (currently) for RedHat based distros._

## Small note for the VM networking

Your VM networking should ideally have only a bridge adapter, which should be able to get dynamically a LAN IP.
(You may want to check with the IT Support whether this is still valid. If not, it can be escalated to the DevOps Team.)

# Execution

## 1. Install Ansible

You need this to bootstrap an environment which is also related to some configurations. Ideally, use the provided script to install it. The version is **7.0.0** as of latest.

```
sudo ./install_ansible.bash -v 7.0.0 -u $USER

# optionally, either open a new terminal tab or do:

su -l $USER
```

If the username is meant to be another username in your system, instead of $USER provide their username, ( _in lowercase and without the $_ )

## 2. Run the Ansible playbook to bootstrap your Python environment

```
ansible-playbook main.yaml -e nodes=localhost
```

# Troubleshooting

## Permission Denied in some tasks

Some tasks in the playbook automatically elevate the permissions, but if you still need to authenticate for it, pass the parameter **-K** in the aforementioned `ansible-playbook` command, to be prompted for your password (hidden).

## Access Denied by Server (for the NFS mount task)

If you are on a VM with VirtualBox which has 2 network interfaces (one in Bridge mode, the other in NAT), the playbook might fail at step "mounts", with "access denied by server".
This is because the command will grab the NAT address instead of the Bridge mode address (which is the one we need to access the NFS server.).
So, you can safely remove a route from your route table, likewise:

Check the route that causes the problem:
```
ip route
```
It should be one in the form of, example:
``` 
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
```
Simply delete it likewise:
```
sudo ip route del default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
```
And remove the NAT interface, if possible.