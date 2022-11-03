`ansible-playbook deploy_lib_r.yaml -i ../hosts [-e rlib_version=1.2.3]`

_note that the text in [] is optional and only meant to be opted if you need to install a previous / other than the latest version_

This is also ran as a job in Jenkins with the following command:

`ansible-playbook ansible/Rserver/deploy_lib_r.yaml -i ansible/hosts --vault-password-file $JENKINS_HOME/secrets/vault_password_file.txt --extra-vars "@ansible/hosts_passwords.yaml" [-e deploy_lib_r=1.2.3]`

**NOTE**: If ran from Jenkins, `$JENKINS_HOME/secrets/vault_password_file.txt` must be the same password that you have encrypted the `hosts_passwords.yaml` .