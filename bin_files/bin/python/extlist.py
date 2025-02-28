#!/usr/bin/env python3
import sys, os, re, argparse
from pprint import pformat

def main():
	parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                     description="Scan a folder (maybe recursively) for text vs binary files (by type)")

	parser.add_argument("root", nargs='?',
						help = 'Specify the folder to scan')
	parser.add_argument("-r", "--recursive", action="store_true", help="if specified, search recursively")
	parser.add_argument("-i", "--ignore-case", action="store_true", help="if specified, ignore case (all output is lowercase)")
	parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")

	cargs = parser.parse_args()
	if cargs.show_args:
		lines = pformat(cargs, indent=4).splitlines()
		args_str = '\n'.join(["    " + ln for ln in lines])
		print("Args:\n{}".format(args_str))
		sys.exit(0)
	if cargs.root is None:
		cargs.root = os.getcwd()

	maxlength = 0
	maxcount = 1
	exts = {}
	for root, dirs, files in os.walk(cargs.root):
		# Prune all the directories if we are not recursive
		if not cargs.recursive:
			dirs[:] = []
		for f in files:
			if '.' in f:
				ext = os.path.splitext(f)[1][1:]
				if not ext:
					# Dot files should probably get ignored, but this is v2 of an older Perl script
					# that used regular expressions instead of a "split extesion" helper function
					assert(f[0] == '.')
					ext = f[1:]
			else:
				ext = "<NA>"
			if cargs.ignore_case:
				ext = ext.lower()
			if len(ext) > maxlength:
				maxlength = len(ext)
			if ext not in exts:
				exts[ext] = 1
			else:
				exts[ext] += 1
				if exts[ext] > maxcount:
					maxcount = exts[ext]

	numlength = len(str(maxcount))
	for ext in sorted(exts.keys()):
		print('{:{}} : {:{}}'.format(ext, maxlength, exts[ext], numlength))

	return 0


if __name__ == '__main__':
	sys.exit(main())
