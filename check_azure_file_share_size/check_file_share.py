#!/usr/bin/python3

"""
AUTHOR : eosantigen
"""


from azure.storage.fileshare import *
import os
import datasize
from  slack_sdk.webhook import WebhookClient


# Full connnection string of a SAS
CONN_STR = ""
SHARE_NAME = ""
DIRECTORY_PATH = ""

# can add more later in a list dynamically, but iterating through the entire share is not optimal, probably.
directory = ShareDirectoryClient.from_connection_string(conn_str=CONN_STR, share_name=SHARE_NAME, directory_path=DIRECTORY_PATH)

share_client = ShareClient.from_connection_string(share_name=SHARE_NAME, conn_str=CONN_STR)

list_directories_and_files = list(directory.list_directories_and_files())

files_with_sizes = {}


def slack_send(awesome_slack_payload: str):

  webhook_url = os.environ['DEVOPS_WEB_HOOK_SLACK_TOKEN']
  webhook = WebhookClient(webhook_url)
  webhook.send(text = awesome_slack_payload)

def directory_total():

    for file in list_directories_and_files:
        print(file['name'], "........", f"{datasize.DataSize(file['size']):GB}")
        files_with_sizes[file['name']] = file['size']

    file_size_sum = sum(files_with_sizes.values())

    print("\nBiggest file for directory... " + f"{DIRECTORY_PATH}: " + max(files_with_sizes, key=files_with_sizes.get) + "\n" + 
            "Biggest file size for directory... " + f"{DIRECTORY_PATH}: " + f"{datasize.DataSize(max(files_with_sizes.values())):GB}" + "\n" +
            "Total for directory... " + f"{DIRECTORY_PATH}: " + f"{datasize.DataSize(file_size_sum):TB}")

def share_total():

    print("Size for entire File Share..." + " " + directory.share_name + " : " + f"{datasize.DataSize(share_client.get_share_stats()):TB}")
    
    if  f"{datasize.DataSize(share_client.get_share_stats()):TB}"  >= "3.5":
        print("OOPS! - CHECK SIZE FOR FILE SHARE: " + f"{directory.share_name}")
        # slack_send("OOPS! CHECK SIZE FOR FILE-SHARE " + f"{file_share.share_name}")
    else:
        print("OK.")


directory_total()
share_total()