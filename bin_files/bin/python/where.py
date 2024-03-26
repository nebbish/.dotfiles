#!/usr/bin/env python3
import os, sys, platform, argparse

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
	parser = argparse.ArgumentParser(description="List each occurance of the provided command in the current PATH")
	parser.add_argument("expr", help = 'Specify the expression to search for')
	cargs = parser.parse_args()

	res = where_impl(cargs.expr)
	for p in res:
		print(p)
	return 0 if len(res) else 1

if __name__ == '__main__':
	sys.exit(main())

