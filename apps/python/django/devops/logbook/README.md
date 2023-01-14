# About

A logbook web app with ActiveDirectory (LDAP) auth and Slack notifications for logged tasks.

# Built on

- [Django](https://docs.djangoproject.com/en/4.1/)
- [django-auth-ldap](https://django-auth-ldap.readthedocs.io)
- [BootstrapVue](https://bootstrap-vue.org)

# Pre-requisites

## For Debian

Base Python should already have been installed in the system by default, especially in Debian-based.

`sudo apt install libldap-common libldap-dev libsasl2-dev python3-dev libssl-dev libsqlite3-dev libncurses-dev liblzma-dev libbz2-dev`

## Python virtual environment setup - using pyenv

Install `pyenv` with the Ansible playbook `python`.

Currently built on `3.10.4` .

1. `pyenv install --list`
2. `pyenv install <some_Python_version>`
3. `cd <the_app_codebase_dir>`
4. `pyenv local <the_Python_version_installed>`
5. Verify local Python version to $PWD: `python --version`
5. `python -m pip install virtualenv`
5. `python -m virtualenv <the_app_codebase_name>`  (or better yet, a simple .venv under $PWD)
6. Activate the virtualenv you just created: `source <the_name_of_the_virtualenv>/bin/activate`

(to deactivate it, just hit `deactivate`.)

# Bootstrap the application (first time)

1. `pip install -r requirements.txt`
2. `./manage.py makemigrations logbook`
3. `./manage.py migrate`

# Run the app

`./manage.py runserver`