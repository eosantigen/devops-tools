# About

A logbook web app with ActiveDirectory (LDAP) auth and Slack notifications for logged tasks.

# Built on

- [Django](https://docs.djangoproject.com/en/4.1/)
- [django-auth-ldap](https://django-auth-ldap.readthedocs.io)
- [BootstrapVue](https://bootstrap-vue.org)

## Pre-requisites

### For Debian

`sudo apt install libldap-common libldap-dev libsasl2-dev python3-dev libssl-dev`

# Python virtual environment setup - using pyenv

Install pyenv with the Ansible playbook.

1. `pyenv install --list`
2. `pyenv install <some_Python_version>`
3. `cd <the_app_codebase_dir>`
4. `pyenv local <the_Python_version_installed>`
5. `pyenv virtualenv <the_app_codebase_name>`
6. `pyenv activate <the_name_of_the_virtualenv>`

# Bootstrap the application (first time)

1. `pip install -r requirements.txt`
2. `./manage.py makemigrations logbook`
3. `./manage.py migrate`

## Run the app

`./manage.py runserver`