#!/usr/bin/env python3
import os, sys, argparse, platform
parser = argparse.ArgumentParser(description="python's readlink() as a command")
parser.add_argument("path", default=None, nargs='?',
					help="path to pass into os.path.realpath()")
parser.add_argument("-f", "--canonicalize", action="store_true",
					help="Ignored by this script")
cargs, _ = parser.parse_known_args()

if platform.system().lower().startswith('win'):
	# For windows we use realpath:
	print(os.path.realpath(cargs.path))
else:
	# For unix, we use readlink - so we also have to catch errors
	try:
		print(os.readlink(cargs.path))
	except OSError:
		sys.exit(1) # print nothing, but exit with a '1'
