#!/usr/bin/env python3
import os, sys, argparse
parser = argparse.ArgumentParser(description="python's readlink() as a command")
parser.add_argument("path", default=None, nargs='?',
					help="path to pass into os.path.realpath()")
parser.add_argument("-f", "--canonicalize", action="store_true",
					help="Ignored by this script")
cargs, _ = parser.parse_known_args()
print(os.path.realpath(cargs.path))
