#!/usr/bin/env python3


from os import walk, path, remove
from argparse import ArgumentParser
from datetime import date, datetime


# Declarations

backup_path = "/home/eosantigen/backup"

def arguments():
  # Initialize argument parser
  argument_parser = ArgumentParser()
  # The number of backup items to keep
  argument_parser.add_argument("-k", "--keep", type=int, required=False, dest="keep", default=3, help="The number of backup items to keep.")
  # The age of backup items to keep
  argument_parser.add_argument("-a", "--age", type=int, required=False, dest="age", default=10, help="The age of backup items to keep.")

  args = argument_parser.parse_args()

  return args


def days_between(file_date, current_date):
  current_date = date.today()
  return abs((current_date - file_date).days)

def clean(keep: int, age: int):
  
  current_date = date.today().strftime("%Y_%m_%d")

  items = []

  tree = walk(f'{backup_path}')

  for (root, dirs, files) in tree:
    for file in files[keep:]:
      # exclude files which include the current_date (relative to the script execution date), and also exclude the items not yet of age.
      if current_date not in file and days_between(date.fromtimestamp(path.getmtime(f'{root}/{file}')), date.today()) >= age:
        items.append(f'{root}/{file}')
    

  # Add an ascending order from the older ones to most recent top-down.
  items.sort(reverse=False, key=path.getmtime)

  for item in items:
    print("Deleting: ", item, "-> Created/Modified at: ", datetime.fromtimestamp(path.getmtime(item)))
    remove(item)


if __name__ == '__main__':

  parsed_args = arguments()

  clean(keep=parsed_args.keep, age=parsed_args.age)