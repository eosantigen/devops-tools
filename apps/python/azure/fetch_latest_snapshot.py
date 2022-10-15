#!/usr/bin/env python3

import os
from json import loads

list_command = os.popen("az snapshot list").read()

output = loads(list_command)

main_db_snapshot_list = []

for i in output:
    if "maindb" in i['id']:
        main_db_snapshot_list.append(i['id'])
    pass

# SORT IN REVERSE TO GRAB MOST RECENT FIRST ON INDEX0
main_db_snapshot_list.sort(reverse=True)

print (main_db_snapshot_list[0])