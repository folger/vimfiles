import os
import re
import sys

import inspect
currentpath = os.path.dirname(inspect.getfile(inspect.currentframe()))

patterns = [''] + sys.argv[1].split() + ['']
pattern = re.compile('(\w|:)*'.join(patterns), re.I)

with open(os.path.join(currentpath, 'tags')) as f:
    for line in f:
        entries = line.split(';"')
        name = entries[0].split('\t')[0]
        if pattern.match(name):
            if entries[1].find('class:') > 0 and name.find('::') < 0:
                continue
            print(entries[0])
