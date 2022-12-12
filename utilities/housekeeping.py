#!/usr/bin/env python3

import os
import argparse
from datetime import date, datetime

# Declarations
# NOTE: The strings in backup_types must match the mountpoints
backup_types = ('devkube', 'vm', 'dc')
backup_items = {}
backup_path = "/Users/eosantigen/Downloads/"


def arguments():
  # Initialize argument parser
  argument_parser= argparse.ArgumentParser()
  # The type of backup item
  argument_parser.add_argument("-t", "--backup_type", type=str, required=True, default=None, choices=backup_types, help="The type of the backup item, which corresponds to the moutpoint.")
  # The number of backup items to keep
  argument_parser.add_argument("-k", "--keep", type=int, required=True, default=3, help="The number of backup items to keep.")

def files():
  my_files = []
  tree = os.walk(backup_path)
  for(root, dirs, files) in tree:
    for filename in files:
      my_files.append(filename)
  yield my_files

for f in files():
  global filename
  filename = [ i for i in f ]


backup_items = backup_items.fromkeys(backup_types, filename)

print(backup_items)