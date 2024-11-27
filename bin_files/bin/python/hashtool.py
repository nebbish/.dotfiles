#!/usr/bin/env python3
import os, sys, argparse, hashlib, codecs


def main():
	parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
	                                 description="Rename/Copy specified file, adding the file mod/cre time as a suffix/prefix")

	parser.add_argument("path", default=None, nargs='?',
						help = "Specify the file to work with")
	parser.add_argument("-t", "--type", default='sha256', choices=['md5','sha1','sha256'],
						help="specify the type of hash to calculate")
	cargs = parser.parse_args()

	if cargs.path is None:
		# NOTE:  if VIM is calling this script as an external program, it will
		#        PREPEND the BOM to the portion of the buffer sent to the external
		#        program WHEN the buffer itself starts with a BOM.
		#        (see:  https://stackoverflow.com/q/51480423/5844631)
		with codecs.getreader('utf_8_sig')(sys.stdin, errors='replace') as stdin:
			data = stdin.read()
	else:
		with open(cargs.path, 'rb') as f:
			data = f.read()

	res = getattr(hashlib, cargs.type)(data)
	print(res.hexdigest())
	return 0

if __name__ == '__main__':
	sys.exit(main())

