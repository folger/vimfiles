import os
import re
import sys

import inspect
currentpath = os.path.dirname(inspect.getfile(inspect.currentframe()))

patterns = [''] + sys.argv[1].split() + ['']
pattern = re.compile('(\w|:)*'.join(patterns), re.I)

with open(os.path.join(currentpath, 'tags')) as f:
    for line in f:
        entry = line.split(';"')[0]
        name = entry.split('\t')[0]
        if pattern.match(name):
            print(entry)
