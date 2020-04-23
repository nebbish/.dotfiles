#!/usr/bin/env python2
from __future__ import print_function

import inspect, logging, sys, os, re
import argparse, platform
import subprocess
from pprint import pprint, pformat
import json

# Disable PYC files for our user-modules
sys.dont_write_bytecode = True

def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def app_log():
	return logging.getLogger(__name__ if __name__ != '__main__' else os.path.splitext(os.path.basename(__file__))[0])
app_log().setLevel(logging.DEBUG)


def run_child(cmdargs, exp_rc=None, *args, **kwargs):
	app_log().info('Running:  {}'.format(cmdargs))
	proc = subprocess.Popen(cmdargs, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, *args, **kwargs)
	(stdout, _) = proc.communicate()
	if exp_rc is not None and exp_rc != proc.returncode:
		stdout_msg = '\n\t'.join(stdout.split('\n')).rstrip() if stdout else 'None'
		eprint('...cmd returned unexpected error code\n    stdout:\n\t{}\n'.format(stdout_msg))
		raise RuntimeError('child process returned [{}] but expected [{}]'.format(proc.returncode, exp_rc))
	return (proc.returncode, stdout)

class Tee(object):
	"""
	This object is designed to intercept a STD stream (stdout/stderr)

	The purpose is to "log" that intercepted output so the STD output can be preserved for
	"offline" or later analysis.  Very handy when this script runs in an automated environment

	log_name:   this is the name of the logger used
	log_path:   the desination log file (can be omitted and added later via set_destination())
	echo:       controls whether the messages are echoed to the original file handle

	NOTE:  'set_destination' will fail if a log_path has already been set up
           (either during construction, or via a previous call to set_destination)
	"""
	def __init__(self, orig_fh, log_name, log_path=None, echo=True):
		self.orig_fh = orig_fh
		self.handler = None
		self.echo = echo
		self.logger = logging.getLogger(log_name)
		self.logger.setLevel(logging.INFO) # info is ok, cause 'info()' is all we use in here
		#self.logger.addHandler(logging.NullHandler())
		if log_path is not None:
			self.set_destination(log_path)

	def orig_out(self):
		return self.orig_fh

	def make_filter(self, name):
		class TeelogFilter(logging.Filter):
			def __init__(self, myname, name_to_filter):
				self.myname = myname
				self.name_to_filter = name_to_filter
			def filter(self, record):
				if record.name == self.name_to_filter:
					return False
				return True
		return TeelogFilter(name, self.logger.name)

	def logger_name(self):
		return self.logger.name

	def set_echo(self, value):
		self.echo = value

	def set_destination(self, path):
		assert(self.handler is None)
		self.handler = logging.FileHandler(path)
		self.handler.setFormatter(logging.Formatter('%(asctime)s : %(message)s'))
		self.logger.addHandler(self.handler)

	def write(self, text):
		##
		##  NOTE: the built-in print() function always calls us at least twice
		##        once with the args the user provided - then with just '\n'
		if self.echo:
			# for echoing, just pass the raw text through every time
			self.orig_fh.write(text)
		# but for logging, we ignore strings that are just '\n'
		if text != '\n':
			self.logger.info(text.rstrip())

	def flush(self):
		self.orig_fh.flush()

	def __getattr__(self, name):
		""" Forwards to the original file handle """
		return getattr(self.orig_fh, name)

## Over-ride the base class, really just to add some command line options
class ToolApp(object):
	"""
	Read in valid JSON data and write it back out "pretty" style.
	"""
	def __init__(self):
		self.log = app_log().getChild('ToolApp')
		self.app_name = app_log().name
		self.args = None
		self.unknown_args = None

		##
		## Next, intercept the NORMAL std handles with the Tee() object defined above
		## It can be configured to echo or not - and to log or not
		## It starts with echo as True, and no logging
		##
		sys.stdout = self.teeout = Tee(sys.stdout, '{0}.stdout'.format(self.app_name))
		sys.stderr = self.teeerr = Tee(sys.stderr, '{0}.stderr'.format(self.app_name))

		##
		## Finally, setup the root logger to process every message, but install
		## a stream handler that will initially only allow warnings and above
		##
		## NOTE:    for this stream handler, we add a filter that will block records
		##          logged by our STD handle intercepters (installed just below)
		##          so the intercepted STD output will not get re-printed
		##
		self.consoleHandler = logging.StreamHandler(self.teeerr.orig_out())
		self.consoleHandler.setLevel(logging.ERROR)
		self.consoleHandler.setFormatter(logging.Formatter('%(name)-25s : %(levelname)-8s : %(message)s'))
		self.consoleHandler.addFilter(self.teeout.make_filter('root_console_handler'))
		self.consoleHandler.addFilter(self.teeerr.make_filter('root_console_handler'))
		logging.getLogger('').setLevel(logging.DEBUG)
		logging.getLogger('').addHandler(self.consoleHandler)

	def parseCmdLine(self, user_args=None, want_unknowns=False):
		##
		## Construct the parser, and setup the options
		##
		parser = argparse.ArgumentParser(description=inspect.getdoc(self))

		##
		## Handy options that should be available on every cmd-line script
		##
		parser.add_argument("-l", "--logdir", dest="logdir", default=None,
							help="specify the folder for our various log files")
		parser.add_argument("-ll", "--log-level", dest="log_level", default='info',
							choices=['debug', 'info', 'warn', 'error', 'critical'],
							help="specify the log level (requires --logdir to be specified")
		parser.add_argument("-q", "--quiet", dest="quiet", default=0, action="count",
							help="don't print results or status messages to stdout")
		parser.add_argument("-v", "--verbose", dest="verbose", default=0, action="count",
							help="log 'info' level messages to STDOUT (normally >= warnings go there)")
		parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")


		##
		## Here are the options specific to this cmd-line script
		##
		parser.add_argument("infile", default=None, nargs='?',
							help="Specify the input file to process")
		parser.add_argument("-o", "--outfile", dest="outfile", default=None, const="", nargs='?',
							help="Specify where to write the output (otherwise its stdout).\n" +
								 "If specified with no arguments, it writes back to the input file")


		##
		## Next, run the parser and save the arguments to our data members
		##
		self.args, self.unknown_args = parser.parse_known_args(args=user_args)
		if self.args.show_args:
			lines = pformat(self.args, indent=4).splitlines()
			args_str = '\n'.join(["    " + ln for ln in lines])
			print("Args:\n{}".format(args_str))
			sys.exit(0)


		##
		## Handle quiet or verbose
		##
		if self.args.quiet > 0:
			if self.args.verbose > 0:
				raise Exception('Both -q and -v cannot both be specified on cmd-line')
			self.teeout.set_echo(False)
			if self.args.quiet > 2:
				self.consoleHandler.setLevel(logging.CRITICAL + 1)
				self.teeerr.set_echo(False)
			elif self.args.quiet > 1:
				self.consoleHandler.setLevel(logging.CRITICAL)
				self.teeerr.set_echo(False)
		elif self.args.verbose > 2:
			self.consoleHandler.setLevel(logging.DEBUG)
		elif self.args.verbose > 1:
			self.consoleHandler.setLevel(logging.INFO)
		elif self.args.verbose > 0:
			self.consoleHandler.setLevel(logging.WARN)

		##
		## Handle the logdir if provided.
		##
		if self.args.logdir is not None:
			## Make sure the folder exists, or create it - then build the 3 output file paths
			if not os.path.exists(self.args.logdir):
				os.makedirs(self.args.logdir)
			self.logdir = os.path.abspath(self.args.logdir)

			##
			## The main script will create 3 files:
			##
			##      <app_name>_logger.txt   Filled by the Root logger
			##      <app_name>_stdout.txt   Filled by what our stdout Tee() interceptor catches
			##      <app_name>_stderr.txt   Filled by what our stderr Tee() interceptor catches
			##
			fh = logging.FileHandler(os.path.join(self.logdir, '{0}_logger.txt'.format(self.app_name)))
			fh.setFormatter(logging.Formatter('%(asctime)s : %(threadName)-10s : %(name)-25s : %(levelname)-8s : %(message)s'))
			fh.setLevel(self.args.log_level.upper())
			logging.getLogger('').addHandler(fh)
			self.teeout.set_destination(os.path.join(self.logdir, '{0}_stdout.txt'.format(self.app_name)))
			self.teeerr.set_destination(os.path.join(self.logdir, '{0}_stderr.txt'.format(self.app_name)))

		##
		## Next handle the specific options
		##
		if self.args.infile is not None and not os.path.exists(self.args.infile):
			raise argparse.ArgumentTypeError("The 'infile' argument cannot be found")
		if self.args.outfile == '':
			self.args.outfile = self.args.infile

		##
		## Here we return the options in case 'main' wants them
		##
		if want_unknowns:
			return self.args, self.unknown_args
		return self.args

	def DoWork(self):
		if self.args.infile is None:
			raw_data = sys.stdin.read()
		else:
			with open(self.args.infile, 'r') as f:
				raw_data = f.read()

		try:
			data = json.loads(raw_data)
		except ValueError as e:
			print('invalid json: %s' % e)
			return -1

		outstr = json.dumps(data, indent=4, sort_keys=True)
		if self.args.outfile is None:
			print(outstr)
		else:
			with open(self.args.outfile, 'w') as f:
				f.write(outstr + '\n')
		return 0

def show_args(args):
	lines = pformat(args, indent=4).splitlines()
	args_str = '\n'.join(["    " + ln for ln in lines])
	print("Args:\n{}".format(args_str))

## This is the main function, called from below
def main():
	logging.getLogger().addHandler(logging.NullHandler())

	## Initialize the application object, and parse the command line
	## (see ToolApp for all the work done here)
	app = ToolApp()
	args = app.parseCmdLine()
	app.DoWork()
	return 0

##
## Now do the main work!
##
if __name__ == '__main__':
	sys.exit(main())

