#!/usr/bin/env python3

from os import system, walk
from argparse import ArgumentParser
from datetime import date

# Declarations
# NOTE: The strings in backup_types must match the mountpoints
backup_types = {'devkube', 'vm', 'dc'}
backup_path = "/Users/eosantigen/Downloads"

def arguments():
  # Initialize argument parser
  argument_parser = ArgumentParser()
  # The type of the backup item, which corresponds to the moutpoint
  argument_parser.add_argument("-t", "--backup_type", type=str, required=True, dest="type", default=None, choices=backup_types, help="The type of the backup item, which corresponds to the moutpoint.")
  # The number of backup items to keep
  argument_parser.add_argument("-k", "--keep", type=int, required=False, dest="keep", default=3, help="The number of backup items to keep.")

  args = argument_parser.parse_args()

  return args

# Traverse the path for list the backup items
def list_backup_items(backup_type: str):

  backup_items = []
  tree = walk(f'{backup_path}/{backup_type}')
  for (root, dirs, files) in tree:
    for files in files:
      backup_items.append(f'{backup_path}/{backup_type}/{files}')
  yield backup_items

def clean(backup_type: str, keep: int):
  
  items_to_delete = []
  current_date = date.today().strftime("%Y_%m_%d")
  delete_command = "rm"

  # Populate a list of filenames from the Generator list_backup_items()
  # Cut the list from the index of the keep parameter also keeping the file that includes the current_date.
  # Reverse is True because we want to keep the most recent ones on top.
  for backup_items in list_backup_items(backup_type):
    filenames = sorted([ b for b in backup_items ], reverse=True)
    for f in filenames[keep:]:
      if current_date not in f:
        items_to_delete.append(f)

  # Execute 
  for item_to_delete in items_to_delete:
    print("To be deleted: ", item_to_delete)
    system(delete_command + " " + f'{item_to_delete}')

if __name__ == '__main__':

  parsed_args = arguments()

  if parsed_args.type in backup_types:
    clean(backup_type=parsed_args.type, keep=parsed_args.keep)