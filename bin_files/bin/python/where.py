#!/usr/bin/env python2
import os, sys, platform, argparse

in_win = platform.system().lower().startswith('win')
def main():
	parser = argparse.ArgumentParser(description="List each occurance of the provided command in the current PATH")
	parser.add_argument("expr", help = 'Specify the expression to search for')
	cargs = parser.parse_args()

	found_one = False
	exts = ['']
	if in_win: exts += os.environ['PATHEXT'].split(os.pathsep)
	for p in os.environ['PATH'].split(os.pathsep):
		for e in exts:
			path = os.path.join(p, cargs.expr + e)
			if os.path.exists(path):
				print(path)
				found_one = True
	return 0 if found_one else 1

if __name__ == '__main__':
	sys.exit(main())

