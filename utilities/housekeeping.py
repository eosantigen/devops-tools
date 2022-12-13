#!/usr/bin/env python3

import os
from glob import glob
from argparse import ArgumentParser
from datetime import date, datetime

# Declarations
# NOTE: The strings in backup_types must match the mountpoints
backup_types = {'devkube', 'vm', 'dc'}
backup_items = {}
backup_path = "/Users/eosantigen/Downloads/"

def arguments():
  # Initialize argument parser
  argument_parser = ArgumentParser()
  # The type of the backup item, which corresponds to the moutpoint
  argument_parser.add_argument("-t", "--backup_type", type=str, required=True, dest="type", default=None, choices=backup_types, help="The type of the backup item, which corresponds to the moutpoint.")
  # The number of backup items to keep
  argument_parser.add_argument("-k", "--keep", type=int, required=False, dest="keep", default=3, help="The number of backup items to keep.")
  # The maximum age of a backup item in days before it gets deleted
  argument_parser.add_argument("-a", "--max_age", type=int, required=False, dest="max_age", default=7, help="The maximum age of a backup item in days before it gets deleted.")

  args = argument_parser.parse_args()

  return args

# Extract and return the days property from an age difference
def age_diff(day_start, day_end):

  day_start = datetime.strptime(day_start, "%Y_%m_%d")
  day_end = datetime.strptime(day_end, "%Y_%m_%d")
  
  return abs((day_end - day_start).days)

# Traverse the path for list the backup items
def list_backup_items(backup_type: str):

  backup_files = []
  tree = os.walk(backup_path+backup_type)
  for(root, dirs, files) in tree:
    for filename in files:
      backup_files.append(filename)
  yield backup_files

def clean(backup_type: str, keep: int, max_age: int):
  
  current_date = date.today().strftime("%Y_%m_%d")

  # Populate a set of filenames from the Generator list_backup_items()
  for i in list_backup_items(backup_type):
    # global filenames
    filenames = [ f for f in i ]
    for f in filenames:
      print(f)

  # backup_items_dict = backup_items.fromkeys(backup_types, filenames)

  # print(backup_items_dict)

if __name__ == '__main__':

  parsed_args = arguments()

  if parsed_args.type in backup_types:
    clean(backup_type=parsed_args.type, keep=parsed_args.keep, max_age=parsed_args.max_age)