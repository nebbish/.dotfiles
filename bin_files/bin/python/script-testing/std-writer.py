#!/usr/bin/env python3
import sys

cargs = sys.argv[1:]
out = err = False
retval = 0

if 'out' in cargs:
	out = True
	cargs.remove('out')
if 'err' in cargs:
	err = True
	cargs.remove('err')
if cargs:
	retval = int(cargs[0])

if out:
	sys.stdout.write('stdout one\n')
if err:
	sys.stderr.write('stderr one\n')
if out:
	sys.stdout.write('stdout two\n')
if err:
	sys.stderr.write('stderr two\n')

sys.exit(retval)
