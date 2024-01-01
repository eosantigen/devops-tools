#!/usr/bin/env python

import datasize
import os
from environs import Env
from azure.storage.fileshare import ShareServiceClient, ShareDirectoryClient
from slack_sdk.webhook import WebhookClient

# Env vars

AFS_LIST = Env()
CONN_STR = os.environ['CONN_STR']
SLACK_WEBHOOK_TOKEN = os.environ['SLACK_WEBHOOK_TOKEN']

FILESHARES = AFS_LIST.list("AFS")

share_service_client = ShareServiceClient.from_connection_string(conn_str=CONN_STR)

files_with_sizes = {}

def slack_send(slack_payload: str):

  webhook_url = SLACK_WEBHOOK_TOKEN
  webhook = WebhookClient(webhook_url)
  webhook.send(text = slack_payload)


def share_client():

    share_clients = []

    for share in FILESHARES:
        share_clients.append(share_service_client.get_share_client(share=share))
    return share_clients


def share_directory_client():
    
    share_directory_clients = []

    for share in FILESHARES:
        share_directory_clients.append(ShareDirectoryClient.from_connection_string(conn_str=CONN_STR, share_name=share, directory_path="./"))
    return share_directory_clients


def share_subdirs(dir_client, dir_name):

    sub_client = dir_client.get_subdirectory_client(directory_name=dir_name)
    sub_files = sub_client.list_directories_and_files()

    for file in sub_files:
       if file['is_directory'] == True:
            share_subdirs(sub_client, file['name'])
       else:
            files_with_sizes[file['name']] = file['size']
    return files_with_sizes
          

def share_dirs_files(limit_dir: str):
    
    for dir_client in share_directory_client():
        for file in list(dir_client.list_directories_and_files(name_starts_with=limit_dir)):
            if file['is_directory'] == True:
                share_subdirs(dir_client, file['name'])
            else:
                files_with_sizes[file['name']] = file['size']
    return files_with_sizes


def share_dirs_files_size(limit_dir: str):

    for file,size in share_dirs_files(limit_dir).items():  
        print(file, "........", f"{datasize.DataSize(size):B}")
    file_size_sum = sum(share_dirs_files(limit_dir).values())

    # This once used to work, but not anyumore -> ValueError: 'pieChart.json' invalid unit: 'json': 
    # Biggest file for directory: " + f"{limit_dir}" + " ........" + f"{datasize.DataSize(max(share_dirs_files(limit_dir), key=share_dirs_files(limit_dir).get)):GB}"

    print("\n" + "Biggest file size in Bytes for directory: " + f"{limit_dir}" + "........" + f"{datasize.DataSize(max(share_dirs_files(limit_dir).values())):B}" + "\n" +
            "Total size in Bytes for directory: " + f"{limit_dir}" + "........ " + f"{datasize.DataSize(file_size_sum):B}")


def share_total():

    """
    get_share_properties 	Returns all user-defined metadata and system properties for the specified share. The data returned does not include the shares's list of files or directories.
    get_share_stats 	    Gets the approximate size of the data stored on the share in bytes.
    """

    for client in share_client():

        share_stats_usage = f"{datasize.DataSize(client.get_share_stats()):GB}".removesuffix("GB")
        usage_percentage = (int(float(share_stats_usage)) / client.get_share_properties()['quota']) * 100

        print("\n" + f"Azure File Share: {client.share_name}".upper() + "\n" + "."*len(f"Azure File Share: {client.share_name}".upper()))
        print("\n" + f"Current usage for entire File Share (in GB) : {datasize.DataSize(client.get_share_stats()):GB}")
        print("\n" + f"Assigned Quota for entire File Share (in GB) : {client.get_share_properties()['quota']}")

        print("Usage (in percent, approximate, rounded up about %4): ", round(usage_percentage), "%")
    
        if usage_percentage >= 90:
            print(f"Share total size reached threshold (>90%) : {client.share_name}")
            slack_send(f"Share total size reached threshold (>90%) : {client.share_name}")
        else:
            print("\n" + "Total usage status: OK.")


if __name__ == '__main__':
    # For now, let's use only the share_total() functionality, in order to be checking multiple FileShares, so we can for now ignore the recursion into subfolders, which needs refactoring.
    # share_dirs_files_size(limit_dir="tethys")
    share_total()