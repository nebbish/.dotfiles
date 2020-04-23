#!/usr/bin/env python

import sys
import pdb
import time
import argparse
import pprint

class Unbuffered(object):
	"""
	Idea from:  http://stackoverflow.com/a/107717/5844631
	"""
	def __init__(self, stream):
		self.stream = stream
	def write(self, data):
		self.stream.write(data)
		self.stream.flush()
	def __getattr__(self, attr):
		return getattr(self.stream, attr)

def set_trace(args):
	if args.pdb_obj:
		pdb.Pdb(stdout=open('/dev/tty', 'w')).set_trace()
	else:
		pdb.set_trace()

def main(args):
	if args.ub_std:
		sys.stdout = Unbuffered(sys.stdout)
		sys.stderr = Unbuffered(sys.stderr)

	print('child running...  {}'.format(' '.join(sys.argv)))

	print('[child] (rnd 1) sys.stdin.isatty() = {}'.format('True' if sys.stdin.isatty() else 'False'))
	print('[child] (rnd 1) sys.stdout.isatty() = {}'.format('True' if sys.stdout.isatty() else 'False'))
	print('[child] (rnd 1) sys.stderr.isatty() = {}'.format('True' if sys.stderr.isatty() else 'False'))

	# Without this 'sleep' - the below messages (when going *straight* to the TTY) get printed first
	if args.sleep is not None:
		time.sleep(args.sleep)

	if args.tty_std:
		sys.stdout = open('/dev/tty', 'w')
		sys.stderr = open('/dev/tty', 'w')

	print('[child] (rnd 2) sys.stdin.isatty() = {}'.format('True' if sys.stdin.isatty() else 'False'))
	print('[child] (rnd 2) sys.stdout.isatty() = {}'.format('True' if sys.stdout.isatty() else 'False'))
	print('[child] (rnd 2) sys.stderr.isatty() = {}'.format('True' if sys.stderr.isatty() else 'False'))


	print('\n')

	rval = 0
	set_trace(args)
	return rval

if __name__ == '__main__':
	ap = argparse.ArgumentParser(add_help=True)
	ap.add_argument("--pdb_obj", dest="pdb_obj", action="store_true", help="use Pdb object with explicit 'tty' stdout")
	ap.add_argument("--ub_std", dest="ub_std", action="store_true", help="setup the stdout/stderr to be unbuffered")
	ap.add_argument("--sleep", dest="sleep", default=None, help="sleep for this many seconds (prior to 2nd round of printing)")
	ap.add_argument("--tty_std", dest="tty_std", action="store_true", help="setup the stdout/stderr to be *direct* to TTY (prior to 2nd round of printing")
	args = ap.parse_args()

	sys.exit(main(args))

