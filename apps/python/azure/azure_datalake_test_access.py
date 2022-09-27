#!/usr/bin/python3

# USE THIS ON A NOTEBOOK -> %python

from azure.storage.filedatalake import DataLakeServiceClient

from azure.identity import ClientSecretCredential

tenant_id = ""
client_id = "" # refers to an App Registration AppID
client_secret = ""
file_system = ""
sa_name = ""

credential = ClientSecretCredential(tenant_id, client_id, client_secret)

service = DataLakeServiceClient(account_url="https://"+sa_name+".dfs.core.windows.net/", credential=credential)

filesystem = service.get_file_system_client(file_system)


paths = filesystem.get_paths()
for path in paths:
    print(path.name + '\n')
