#!/usr/bin/env python3
import os, sys, platform

sys.dont_write_bytecode = True

def where_impl(val):
	found = []
	exts = ['']
	in_win = platform.system().lower().startswith('win')
	if in_win: exts += os.environ['PATHEXT'].split(os.pathsep)
	for p in os.environ['PATH'].split(os.pathsep):
		for e in exts:
			path = os.path.join(p, val + e)
			if os.path.exists(path):
				found.append(path)
	return found


def main():
	tool = where_impl('clang-format')[0]

	if len(sys.argv) == 1:
		# Process STDIN with remainder of PROCESS (i.e.  and then quit)
		os.execv(tool, ['-style=file'])
	
	# This returns a file-like object whose .close() method returns the
	# exit code of the child process....   we ignore it for this pre-edit
	os.popen('p4 edit "{}" 2>/dev/null'.format(sys.argv[1])).close()

	# Process the specified file with the remainder of PROCESS
	os.execv(tool, ['-style=file', '-i', sys.argv[1]])


if __name__ == '__main__':
	sys.exit(main())

