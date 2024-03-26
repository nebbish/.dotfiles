#!/usr/bin/env python3
import inspect, logging, sys, os
import re
import argparse


################################################################################
## Logging helper
##
def mod_log():
	"""Utility to automatically access the 'root' logger when __name__=='__main__'"""
	return logging.getLogger(__name__ if __name__ != '__main__' else '')
# This is important in case the user does not setup their own handlers
# (to suppress annoying 'no handler' messages to STDERR)
mod_log().addHandler(logging.NullHandler())

## Over-ride the base class, really just to add some command line options
class RmDupsApp(object):
	"""
	Process the input line by line, stripping out duplicate lines
	"""
	def __init__(self):
		super(RmDupsApp, self).__init__()
		self.log = mod_log().getChild('RmDupsApp')
		self.args = None

	def processCmdLineArgs(self, user_args=None):
		parser = argparse.ArgumentParser(description=inspect.getdoc(self))
		parser.add_argument("infile", default=None, nargs='?',
							help="Specify the input file to process")
		parser.add_argument("-c", "--count", dest="count", action="store_true",
							help="Specify this flag to prefix each line with the # of times encontered")
		parser.add_argument("-o", "--outfile", dest="outfile", default=None, const="", nargs='?',
							help="Specify where to write the output (otherwise its stdout).\n" +
								 "If specified with no arguments, it writes back to the input file")

		self.args = args = parser.parse_args(args=user_args)
		if args.infile is not None and not os.path.exists(args.infile):
			raise argparse.ArgumentTypeError("The 'infile' argument cannot be found")
		if args.outfile == '':
			args.outfile = args.infile
		self.args = args

	def DoWork(self):
		self.processCmdLineArgs()
		if self.args.infile is None:
			lines = [ln.rstrip() for ln in sys.stdin]
		else:
			with open(self.args.infile, 'r') as f:
				lines = [ln.rstrip() for ln in f]

		uniqs = []
		data = {}
		for ln in lines:
			if ln in data:
				data[ln] += 1
			else:
				uniqs.append(ln)
				data[ln] = 1

		if self.args.count:
			c_width = len(str(max(data.values())))
			uniqs = ['{:0{}}: {}'.format(data[ln], c_width, ln) for ln in uniqs]
		
		if self.args.outfile:
			with open(self.args.outfile, 'w') as f:
				f.write('\n'.join(uniqs) + '\n')
		else:
			print('\n'.join(uniqs))



## This is the main function, called from below
def main():
	## Setup the root logger to output errors and above to the console

	## Initialize the application object, and parse the command line
	## (see RmDupsApp for all the work done here)
	app = RmDupsApp()
	app.DoWork()

##
## Now do the main work!
##
if __name__ == '__main__':
	main()

