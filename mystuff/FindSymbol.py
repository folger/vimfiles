import os
import sys

import inspect
currentpath = os.path.dirname(inspect.getfile(inspect.currentframe()))

patterns = [s.lower() for s in sys.argv[1].split()]

def match(name):
    global patterns
    name = name.lower()
    for pattern in patterns:
        if name.find(pattern) < 0:
            return False
    return True

with open(os.path.join(currentpath, 'tags')) as f:
    for line in f:
        if line[0] == '!':
            continue
        entries = line.split(';"')
        name = entries[0].split('\t')[0]
        if entries[1].find('class:') > 0 and name.find('::') < 0:
            continue
        if match(name):
            print(entries[0])
