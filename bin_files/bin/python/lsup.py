#!/usr/bin/env python3

import sys, os

for arg in sys.argv[1:]:
    while arg:
        os.system(f"ls -lad {arg}")
        newarg = os.path.split(arg)[0]
        arg = None if newarg == arg else newarg
