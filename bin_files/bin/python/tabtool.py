#!/usr/bin/env python2
from __future__ import print_function

import inspect, logging, sys, os, re
import argparse, platform
import subprocess
from pprint import pformat

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
class TabToolApp(object):
	"""
	Read in a text document and re-format the whitespace to/from spaces/tabs
	"""
	def __init__(self):
		self.log = app_log().getChild('TabToolApp')
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
		parser.add_argument("-tw", "--tab-width", dest="tabwidth", type=int, default=4,
							help="Specify the width of a tab (default is 4)")
		parser.add_argument("-clt", "--convert-leading-to-tabs", dest="leadtotabs", action="store_true",
							help="Specify this flag to convert leading spaces to tabs")
		parser.add_argument("-cat", "--convert-all-to-tabs", dest="alltotabs", action="store_true",
							help="Specify this flag to convert all spaces to tabs")
		parser.add_argument("-cls", "--convert-leading-to-spaces", dest="leadtospaces", action="store_true",
							help="Specify this flag to convert leading tabs to spaces")
		parser.add_argument("-cas", "--convert-all-to-spaces", dest="alltospaces", action="store_true",
							help="Specify this flag to convert all tabs to spaces")
		parser.add_argument("-rus", "--remove-useless-spaces", dest="ruspaces", action="store_true",
							help="Specify this flag to remove useless spaces.\n" +
								 "(spaces that immediately precede tabs and don't end on a tabstop)")
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
		self.conv_opts = [self.args.leadtotabs, self.args.alltotabs, self.args.leadtospaces, self.args.alltospaces]
		if len([opt for opt in self.conv_opts if opt]) > 1:
			raise argparse.ArgumentTypeError("Cannot specify more than one of:  '-clt', '-cls', '-cat', '-cas'")
		if self.args.infile is not None and not os.path.exists(self.args.infile):
			raise argparse.ArgumentTypeError("The 'infile' argument [{}] cannot be found".format(self.args.infile))
		if self.args.outfile == '':
			self.args.outfile = self.args.infile

		##
		## Here we return the options in case 'main' wants them
		##
		if want_unknowns:
			return self.args, self.unknown_args
		return self.args

	class SpaceMgr(object):
		def __init__(self, curcol, tabwidth, *args, **kwargs):
			self.tabwidth = tabwidth
			self.startcol = curcol
			self.startgap = tabwidth - (curcol % tabwidth)
			self.curgap = self.startgap
			self.curpart = ''
			self.parts = []
			return super(TabToolApp.SpaceMgr, self).__init__(*args, **kwargs)

		def _push_cur_part(self):
			self.parts.append(self.curpart)
			self.curgap = self.tabwidth
			self.curpart = ''

		def add_char(self, ch):
			if ch not in [' ','\t']:
				raise ValueError("'ch' must be either a space or tab")
			self.curpart += ch
			if ch == ' ':
				self.curgap -= 1
			if ch == '\t' or self.curgap == 0:
				self._push_cur_part()

		def get_len(self):
			if len(self.parts) == 0:
				return len(self.curpart)
			# Use everything but the first part for calculation
			parts = self.parts[1:] + [self.curpart]
			# Use the 'startgap' as the length of the first part we omitted from the calculation
			return sum([self.startgap] + [self.tabwidth if '\t' in p else len(p) for p in parts])

		def convert_to_tabs(self):
			return '\t' * len(self.parts) + self.curpart

		def convert_to_spaces(self):
			s = ''
			numparts = len(self.parts)
			if numparts > 0:
				s = ' ' * self.startgap
				if numparts > 1:
					s += ' ' * (self.tabwidth * (numparts - 1))
			return s + self.curpart

		def rebuild_without_useless_spaces(self):
			parts = ['\t' if '\t' in p else p for p in self.parts]
			return ''.join(parts) + self.curpart

		def rebuild_without_spaces_that_are_followed_by_tabs(self):
			found_tab = False
			parts = []
			for p in reversed(self.parts):
				if '\t' in p:
					parts.append('\t')
					found_tab = True
				elif found_tab:
					parts.append('\t')
				else:
					parts.append(p)
			return ''.join(reversed(parts)) + self.curpart

	def DoWork(self):
		if not any(self.conv_opts + [self.args.ruspaces]):
			print("Quiting early, nothing to do")
			return

		if self.args.infile is None:
			lines = [ln.rstrip() for ln in sys.stdin]
		else:
			with open(self.args.infile, 'r') as f:
				lines = [ln.rstrip() for ln in f]

		line_num = 0
		indent_level = 0
		adj_lines = []
		for ln in lines:
			line_num += 1
			# First split the line into space delimited parts
			# Using 're.split' with a capture group returns the matching delimiters too
			# So, using 'filter(None,...)' will strip the empty strings at the start and end
			# In the docs:   " If function is None, the identity function is assumed, ..."
			parts = filter(None, re.split(r"(\s+)", ln))

			# Next build a list of columns that each part starts on
			cols = [0]  # the first always starts here
			for pidx in range(len(parts)-1):    # skip the last part
				# We use indexing so an adjusted part can be put back into the array of parts
				part = parts[pidx]

				# Calculate the length of this part
				if not part.isspace():
					partlen = len(part)
				else:
					# Here we account for tab width and tab characters
					# NOTE:  the SpaceMgr tool ONLY works if the columns are 0-based indexed
					#        (using the '%' operator on the inside)
					spacer = TabToolApp.SpaceMgr(cols[-1], self.args.tabwidth)
					for c in part:
						spacer.add_char(c)
					partlen = spacer.get_len()

					##
					## This block was my initial thoughts on mixing tabs with spaces for **wrapped** lines
					## so that the 'wrapped' line will use tabs to get to the correct **indent** level, then
					## use spaces to get to where the text *should* begin
					##
					## For example:
					## with ...:
					## ~~~~if condition and \
					## ~~~~   condition2:	# Here, one tab to get to proper indent, then 3 spaces to get desired lineup
					## ~~~~~~~~work()
					##
					#if pidx == 0:
					#	if 0 == (partlen % self.args.tabwidth):
					#		indent = partlen / self.args.tabwidth
					#		print('EVEN: {}  {}'.format(indent, ln))
					#		delta = abs(indent - indent_level)
					#		if delta == 1:
					#			indent_level = indent
					#		elif delta > 1 and indent < indent_level:
					#			cxt = '\n\t'.join(lines[line_num-1:line_num+2])
					#			raise Exception('Unexpected multiple indent drop ({} to {}) at line {}:\n\t{}'.format(indent_level, indent, line_num, cxt))
					#	else:
					#		print('ODD:     {}'.format(ln))

					if self.args.alltotabs or (pidx == 0 and self.args.leadtotabs):
						parts[pidx] = spacer.convert_to_tabs()
					elif self.args.alltospaces or (pidx == 0 and self.args.leadtospaces):
						parts[pidx] = spacer.convert_to_spaces()
					elif self.args.ruspaces:
						# If we want to remove useless spaces:
						parts[pidx] = spacer.rebuild_without_useless_spaces()

				# The next column is just length of the part plus the last column
				cols.append(cols[-1] + partlen)

			debug_printing = False
			if debug_printing:
				# Adjust the columns to 1-based indexing for printing (to compare against editors that show columns)
				cols = [c + 1 for c in cols]
				# Trim the list of columns for printing - to only report where non-space sections start
				cols = [c for (p,c) in zip(parts, cols) if not p.isspace()]
				#print(ln)
				#print("{:<4}{}".format(line_num, pformat(parts, indent=4, width=300))
				print("{:<4}{}".format(line_num, pformat(cols, indent=4, width=300)))

			# Finally, put the possibly adjusted set of parts into the output list of lines
			adj_lines.append(''.join(parts))

		if self.args.outfile:
			with open(self.args.outfile, 'w') as f:
				f.write('\n'.join(adj_lines) + '\n')
		else:
			print('\n'.join(adj_lines))
		return 0

def show_args(args):
	lines = pformat(args, indent=4).splitlines()
	args_str = '\n'.join(["    " + ln for ln in lines])
	print("Args:\n{}".format(args_str))

## This is the main function, called from below
def main():
	logging.getLogger().addHandler(logging.NullHandler())

	## Initialize the application object, and parse the command line
	## (see TabToolApp for all the work done here)
	app = TabToolApp()
	args = app.parseCmdLine()
	app.DoWork()
	return 0

##
## Now do the main work!
##
if __name__ == '__main__':
	sys.exit(main())

