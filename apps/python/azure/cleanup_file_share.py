#!/usr/bin/python3

"""
TODO: probably acquire a SAS on the fly. But that would require the master account keys. The SAS expires in 29/12/2030.
"""

from azure.storage.fileshare import *
import time


CONN_STR = "FileEndpoint=https://<>.file.core.windows.net/;SharedAccessSignature=<>"

file_share = ShareDirectoryClient.from_connection_string(conn_str=CONN_STR, share_name="<>", directory_path="<>")

folders_all = list(file_share.list_directories_and_files())
folders_with_timestamp = list(file_share.list_directories_and_files(name_starts_with="20"))

struct_now_time = time.strptime(time.strftime("%Y_%m_%d"), "%Y_%m_%d")
string_now_time = time.strftime(time.strftime("%Y_%m_%d"))


# Clean up all other folders without timestamp
for folder_not_with_timestamp in folders_all:
    if not (str(folder_not_with_timestamp['name']).startswith("20")):
        print(folder_not_with_timestamp['name'])
        subdirectory = file_share.get_subdirectory_client(directory_name=folder_not_with_timestamp['name'])
        subdirectory_list = subdirectory.list_directories_and_files()
        # Recurse into subdirectories and delete files within first before deleting their folder
        # for file in subdirectory_list:
        #     print(file['name'])
        #     filez = subdirectory.get_file_client(file_name=file['name'])
        #     filez.delete_file()
        subdirectory.delete_directory()

# Clean all folders with timestamp except the one with current timestamp
for folder_with_timestamp in folders_with_timestamp:
    if folder_with_timestamp['name'] not in string_now_time and str(struct_now_time.tm_mon) not in folder_with_timestamp['name'] :
        subdirectory = file_share.get_subdirectory_client(directory_name=folder_with_timestamp['name'])
        subdirectory_list = subdirectory.list_directories_and_files()
        print(folder_with_timestamp['name']) # returns all folders without the current timestamp AND without the current month in their name.
        for file in subdirectory_list:
            if (file['is_directory'] == True):
                inner_folder = file['name']
                print(inner_folder)

                inner_folderz = []
                inner_folderz.append(inner_folder)

                for filez in inner_folderz:
                    inner_folderz_contents = subdirectory.get_subdirectory_client(directory_name=filez)
                    inner_folder_contents = inner_folderz_contents.list_directories_and_files()
                    for f in inner_folder_contents:
                        print(f['name'])
                        filez_to_delete = inner_folderz_contents.get_file_client(f['name'])
                        filez_to_delete.delete_file()
                    inner_folderz_contents.delete_directory()
            else:
                print(file['name'])
                get_filez = subdirectory.get_file_client(file_name=file['name'])
                get_filez.delete_file()
        time.sleep(600)
        subdirectory.delete_directory()
