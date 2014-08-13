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

signature = 'signature:'
with open(os.path.join(currentpath, 'tags')) as f:
    for line in f:
        if line[0] == '!':
            continue
        entries = line.split(';"')
        names = entries[0].split('\t')
        name = names[0]
        if (entries[1].find('::') > 0 or entries[1].find('class:') > 0) and name.find('::') < 0:
            continue
        if match(name):
            sig = entries[1].find(signature)
            if sig >= 0:
                print('\t'.join([name + entries[1][sig+len(signature):-1]] + names[1:]))
            else:
                print(entries[0])
