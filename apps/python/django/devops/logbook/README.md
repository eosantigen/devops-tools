### About

A logbook web app with ActiveDirectory (LDAP) auth and Slack notifications for logged tasks.

### Built on

- [Django](https://docs.djangoproject.com/en/4.1/)
- [django-auth-ldap](https://django-auth-ldap.readthedocs.io)
- [BootstrapVue](https://bootstrap-vue.org)

### Python virtual environment setup

0. `sudo apt install libldap-common libldap-dev libsasl2-dev python3-dev libssl-dev`
1. `python3 -m venv .venv`
2. `source .venv/bin/activate`
3. `pip install -r requirements.txt`
4. `./manage.py makemigrations logbook`
5. `./manage.py migrate`
6. `./manage.py runserver`