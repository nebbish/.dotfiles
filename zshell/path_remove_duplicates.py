#!/usr/bin/env python3

import os
parts = []
for part in os.environ['PATH'].split(os.pathsep):
    if part not in parts:
        parts.append(part)
print('PATH="{}"; export PATH;'.format(os.pathsep.join(parts)))
os.pathsep.join(parts)
