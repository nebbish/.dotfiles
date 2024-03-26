#!/usr/bin/env python3
import os, sys

sys.dont_write_bytecode = True
from where import where_impl

def main():
	tool = where_impl('clang-format')[0]

	if len(sys.argv) == 1:
		os.execv(tool, ['-style=file'])
	
	# This returns a file-like object whose .close() method returns the
	# exit code of the child process....   we ignore it for this pre-edit
	os.popen('p4 edit "{}" 2>/dev/null'.format(sys.argv[1])).close()

	os.execv(tool, ['-style=file', '-i', sys.argv[1]])


if __name__ == '__main__':
	sys.exit(main())

