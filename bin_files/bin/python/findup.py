#!/usr/bin/env python2
import os, sys, glob

def main():
	files = []
	pat = sys.argv[1]
	cur = os.path.abspath(os.getcwd())
	while cur:
		#print('checking {}'.format(cur))
		glob_expr = os.path.join(cur, pat)
		#print('looking for:  {}'.format(glob_expr))
		files += glob.glob(glob_expr)
		#files += [os.path.join(cur, i) for i in os.listdir(cur) if i == '.clang-format']
		parent = os.path.dirname(cur)
		if parent == cur: break
		cur = parent
	if files:
		print("\n\t{}".format("\n\t".join(files)))
	return 0

if __name__ == '__main__':
	if not sys.argv[1]:
		raise Exception('Need something to look for')

	sys.exit(main())

