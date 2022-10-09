#!/usr/bin/env python3

import json
import os
import requests
import subprocess


headers= {
'Accept': 'application/json',
'Content-Type': 'application/json',
'Authorization': 'Basic <base64 string>'
}
source_url = "https://grafana.devanet:3000/api/dashboards/uid/"
source_search_url = "https://grafana.devanet:3000/api/search/"
target_url = "https://grafana.devanet/api/dashboards/db"

r = requests.get(url = source_search_url, headers = headers)

for d in r.json():
    uid = d.get('uid')
    title = d.get('title')    
    filename = title + '.json'
    db = requests.get(url = source_url + uid, headers = headers)
    data = db.json()
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

path = os.walk('d')

for (root, dirs, files) in path:
    for name in files:
        print (name)
        with open("./d/"+name, 'r', encoding='utf-8') as dashboard:
            payload = json.load(dashboard)
            # clean up the id field for recreateing it in import...
            # subprocess.call("jq '.dashboard.id = null' './d/{0}' | sponge './d/{0}'".format(name), shell=True)
            print(requests.post(url=target_url, json=payload, verify=None, headers=headers))

