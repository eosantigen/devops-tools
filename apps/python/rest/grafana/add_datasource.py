#!/usr/bin/env python3

"""
Grafana HTTP API: Create Datasource (latest in use: v9.3)
Script invocation: ./add_datasource.py
"""

import argparse
import requests
from os import environ
from termcolor import cprint
import json

grafana_base_url = ""
grafana_datasource_endpoint = "/api/datasources"
grafana_org_switch_endpoint = "/api/user/using/"


# Define arguments
def arguments():

    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument("--gf-org-id", type=int, dest="gf_org_id", required=True)
    
    args = argument_parser.parse_args()

    return args

def switch_org(org: int):
    switch_org = requests.post(grafana_base_url+grafana_org_switch_endpoint+f'{org}', auth=(environ['GF_ADMIN_USER'], environ['GF_ADMIN_PASSWORD']))

    print("Active Org : ", org)
    print(switch_org.json())


# Execute the request for each requested org.
def add_datasource():

    with open('metis-api-datasource.json') as payload_file:
        payload = payload_file.read()


    request = requests.post(grafana_base_url+grafana_datasource_endpoint, json=json.loads(payload), auth=(environ['GF_ADMIN_USER'], environ['GF_ADMIN_PASSWORD']))

    if request.status_code !=200:
        cprint(request.status_code, "red")
    else:
        cprint(request.status_code, "green")


if __name__ == '__main__':

    parsed_arguments = arguments()

    switch_org(org=parsed_arguments.gf_org_id)
    add_datasource()
