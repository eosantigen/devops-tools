#!/usr/bin/env python3

"""
Example: Grafana API - HTTP
-------------------------------
POST /api/orgs/1/users HTTP/1.1
Accept: application/json
Content-Type: application/json

{
  "loginOrEmail":"user@company.com",
  "role":"Viewer"
}

Script invocation
-------------------------------
./assign_org_users.py [-h] --gf-org-id GF_ORG_ID --gf-role {ADMIN,EDITOR,VIEWER}
"""


import ast
import argparse
import requests
from os import environ
from enum import Enum, unique
from termcolor import cprint


# Use an Enum for defining specific properties, which are unique to Grafana, and use CAPITAL to warn the user that this is a pre-defined CONSTANT.
@unique
class GrafanaRoles(Enum):
    ADMIN = 'Admin'
    EDITOR = 'Editor'
    VIEWER = 'Viewer'

grafana_base_url = "https://live.metis.tech"
grafana_endpoint = "/api/orgs/"+"gf_org_id"+"/users"
gf_role = "" # grab from argument --gf-role
gf_org_id = None # grab from argument --gf_org_id
client_user = "" # gets a value at a later stage through iteration

payload = {
    "loginOrEmail": client_user,
    "role": gf_role
}




# Define arguments
def arguments():

    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument("--gf-org-id", type=int, dest="gf_org_id", required=True)
    argument_parser.add_argument("--gf-role", type=str, dest="gf_role", required=True, choices=GrafanaRoles.__members__.keys())
    
    args = argument_parser.parse_args()

    return args

# Execute the request for each client_user
def gf_request(client_user: str, gf_role: str, gf_org_id: int):
    
    endpoint = grafana_endpoint.replace("gf_org_id", str(gf_org_id))

    loginOrEmail = client_user
    payload.update({"loginOrEmail": loginOrEmail, "role": gf_role})
    print(payload)
    rest_call = requests.post(grafana_base_url+endpoint, json=payload, auth=(environ['GF_ADMIN_USER'], environ['GF_ADMIN_PASSWORD']))
    print(rest_call.json())
    if rest_call.status_code !=200:
        cprint(rest_call.status_code, "red")
    else:
        cprint(rest_call.status_code, "green")

# Fetch the admin list
def fetch_admins():

    admins_file = 'admins.py'

    with open(admins_file) as admins_file:
        admins = admins_file.read()
    admins = ast.literal_eval(admins)

    return set(admins)

# Fetch the editor list
def fetch_editors():

    editors_file = 'editors.py'

    with open(editors_file) as editors_file:
        editors = editors_file.read()
    editors = ast.literal_eval(editors)

    return set(editors)

# Fetch the viewer list
def fetch_viewers():

    viewers_file = 'viewers.py'

    with open(viewers_file) as viewers_file:
        viewers = viewers_file.read()
    viewers = ast.literal_eval(viewers)

    return set(viewers)

# POST request to grafana_endpoint by iterating over the admins list.
def add_admins(gf_org_id):

    gf_role = GrafanaRoles.ADMIN.value
    # endpoint = grafana_endpoint.replace("gf_org_id", str(gf_org_id))

    for client_user in fetch_admins():
        gf_request(client_user, gf_role, gf_org_id)


# POST request to grafana_endpoint by iterating over the editors list.
def add_editors(gf_org_id):

    gf_role = GrafanaRoles.EDITOR.value

    for client_user in fetch_editors():
        gf_request(client_user, gf_role, gf_org_id)


# POST request to grafana_endpoint by iterating over the viewers list.
def add_viewers(gf_org_id):

    gf_role = GrafanaRoles.VIEWER.value

    for client_user in fetch_viewers():
        gf_request(client_user, gf_role, gf_org_id)



if __name__ == '__main__':

    parsed_arguments = arguments()

    if parsed_arguments.gf_role in GrafanaRoles.ADMIN.name:
        add_admins(parsed_arguments.gf_org_id)

    if parsed_arguments.gf_role in GrafanaRoles.EDITOR.name:
        add_editors(parsed_arguments.gf_org_id)
    
    if parsed_arguments.gf_role in GrafanaRoles.VIEWER.name:
        add_viewers(parsed_arguments.gf_org_id)