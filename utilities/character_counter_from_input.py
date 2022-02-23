#!/usr/bin/env python3


from sys import stdin
from collections import Counter


print("Type a string below. (Type ':q' for exit) \n")

for my_input_string in stdin:
    if ':q' == my_input_string.rstrip():
        exit(0)
    my_input_string = my_input_string.rstrip("\n")
    print(f'Your text: {my_input_string}')

    count = Counter(my_input_string)
    total = sum(count.values())

    print("Full character count: ", total, "\n")

print("Done.")

exit(0)
