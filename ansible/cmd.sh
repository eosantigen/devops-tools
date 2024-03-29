# ansible-config init --disabled > /tmp/ansible.cfg
# ansible -m ping all
# ansible-galaxy collection install community.libvirt
ansible-inventory --list -i inventory/hosts.ini
#ansible -m ansible.builtin.setup all --args 'filter=all_ipv4_addresses,dns,interfaces,network,os_family,python_version,user_shell'
ansible-playbook playbooks/packages.yaml -i inventory/hosts.ini --limit ubuntuserverltsvirt --skip-tags=snap -e nodes=ubuntuserverltsvirt -K