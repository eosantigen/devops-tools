#!/usr/bin/env python3

"""
Grafana HTTP API: Create Organization (latest in use: v9.3)
Script invocation: ./add_org.py
"""


import ast
import requests
from os import environ
from termcolor import cprint

grafana_base_url = ""
grafana_org_endpoint = "/api/orgs"


# Execute the request for each requested org.
def gf_request(org: str):

    payload = { "name":org }

    print("ORG TO ADD : ", org)

    request = requests.post(grafana_base_url+grafana_org_endpoint, json=payload, auth=(environ['GF_ADMIN_USER'], environ['GF_ADMIN_PASSWORD']))
    print(request.json())
    if request.status_code !=200:
        cprint(request.status_code, "red")
    else:
        cprint(request.status_code, "green")


# Fetch the clients list to become orgs
def fetch_orgs():

    clients_file = 'orgs.py'

    with open(clients_file) as clients_file:
        orgs = clients_file.read()
    orgs = ast.literal_eval(orgs)

    return set(orgs)


# POST request to GF by iterating over the clients/orgs list.
def add_orgs():
    for org in fetch_orgs():
        gf_request(org)


if __name__ == '__main__':
    add_orgs()