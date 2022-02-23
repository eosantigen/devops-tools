#!/usr/bin/python3

# USE THIS WHEN IN NOTEBOOK -> %python

# CHANGE ACCORDINGLY: the field XXX

import sys
import time

from azure.identity import ClientSecretCredential
from azure.storage.filedatalake import DataLakeServiceClient,FileSystemClient

ACCOUNT_NAME = "XXX"
FILE_SYSTEM = "XXX"
TARGET_DIR = "XXX"

def set_permission(path,acl):
    # Directories and files need to be handled differently
    if path.is_directory:
        directory_client = filesystem.get_directory_client(directory=path.name)
        resp = directory_client.set_access_control(acl=acl)
        print(f'\tApplied Directory ACL to {path.name}')
    else:
        file_client = filesystem.get_file_client(path.name)
        # Need to remove "Default" ACL segments from ACL string because that can't be applied to files
        resp = file_client.set_access_control(acl=acl[:acl.find('default')-1])
        print(f'\tApplied File ACL to {path.name}')
    return resp

def main(target_dir,filesystem):

    # Get the target directory, subdirectories and permissions
    paths = filesystem.get_paths(path=target_dir)
    directory_client = filesystem.get_directory_client(directory=target_dir)
    acl = directory_client.get_access_control()
    target_acl_dir = acl['acl']
    
    for path in paths:
      set_permission(path,target_acl_dir)

if __name__ == '__main__':
    
    # Clients
    credential = "XXX" # the master account key.
    service = DataLakeServiceClient(account_url=f'https://{ACCOUNT_NAME}.dfs.core.windows.net/', credential=credential)
    filesystem = service.get_file_system_client(file_system=FILE_SYSTEM)

    print('*'*20)
    print(f'Storage Account Name: {ACCOUNT_NAME}')
    print(f'File System Name: {FILE_SYSTEM}')
    print('*'*20)
    print(f'Running: Setting ACLs for all child paths (subdirectories and files) in TARGET_DIR to match parent.')
    total_start = time.time() # Start Timing
    main(TARGET_DIR,filesystem)
    total_end = time.time() # End Timing
    print("Complete: Recursive ACL configuration took {} seconds.".format(str(round(total_end - total_start,2))))
