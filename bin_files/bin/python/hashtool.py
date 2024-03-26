#!/usr/bin/env python3
import os, sys, argparse, hashlib


def main():
	parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
	                                 description="Rename/Copy specified file, adding the file mod/cre time as a suffix/prefix")

	parser.add_argument("path", default=None, nargs='?',
						help = "Specify the file to work with")
	parser.add_argument("-t", "--type", default='sha256', choices=['md5','sha1','sha256'],
						help="specify the type of hash to calculate")
	cargs = parser.parse_args()

	if cargs.path is None:
		data = sys.stdin.read()
	else:
		with open(cargs.path, 'rb') as f:
			data = f.read()

	res = getattr(hashlib, cargs.type)(data)
	print(res.hexdigest())
	return 0

if __name__ == '__main__':
	sys.exit(main())

