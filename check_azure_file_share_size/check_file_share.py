#!/usr/bin/python3

"""
AUTHOR : eosantigen
"""

from azure.storage.fileshare import *
import time
import os
import datasize
from  slack_sdk.webhook import WebhookClient



CONN_STR = "" # Full connnection string of a SAS  .
SHARE_NAME = "" # File Share name
DIRECTORY_PATH = "" #  Directory within the file share.

file_share = ShareDirectoryClient.from_connection_string(conn_str=CONN_STR, share_name=SHARE_NAME, directory_path=DIRECTORY_PATH)

files = list(file_share.list_directories_and_files(name_starts_with=time.strftime("%Y.")))

sizes = []

def slack_send(awesome_slack_payload: str):

  webhook_url = os.environ['DEVOPS_WEB_HOOK_SLACK_TOKEN']
  webhook = WebhookClient(webhook_url)
  webhook.send(text = awesome_slack_payload)

for file in files:
    print(file['name'], "........", f"{datasize.DataSize(file['size']):GB}")
    sizes.append(file['size'])

file_size_sum = sum(sizes)
print(f"{datasize.DataSize(file_size_sum):TB}")

if f"{datasize.DataSize(file_size_sum):TB}" >= "3.5":
    print("CHECK SIZE FOR FILE-SHARE" + f"{file_share.share_name}")
    slack_send("CHECK SIZE FOR FILE-SHARE " + f"{file_share.share_name}")
else:
    print("OK.")