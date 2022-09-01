#!/usr/bin/env python3

import sys, os, re, logging, inspect, argparse
from pprint import pprint, pformat
import collections, datetime
import codecs


# Disable PYC files for our user-modules
sys.dont_write_bytecode = True

def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def app_log():
	return logging.getLogger(__name__ if __name__ != '__main__' else os.path.splitext(os.path.basename(__file__))[0])
app_log().setLevel(logging.DEBUG)


class opener(object):
	def __init__(self, path=None, mode='r'):
		self.fh = None
		self.path = path
		if mode not in ['r','w']:
			raise Exception('provided mode [{}] is not yet supported by the "opener" class'.format(mode))
		self.mode = mode

	def __enter__(self):
		if self.path is not None:
			self.fh = open(self.path, self.mode)
			return self.fh
		if self.mode == 'r':
			# OLD code, just return standard handle (no need to close)
			#           adjusted in favor of handling possible BOM just below
			# return sys.stdin

			# NOTE:  if VIM is calling this script as an external program, it will
			#        PREPEND the BOM to the portion of the buffer sent to the external
			#        program WHEN the buffer itself starts with a BOM.
			#        (see:  https://stackoverflow.com/q/51480423/5844631)
			self.fh = codecs.getreader('utf_8_sig')(sys.stdin, errors='replace')
			return self.fh
		return sys.stdout

	def __exit__(self, exception_type, exception_value, traceback):
		if self.fh:
			self.fh.close()


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


class App(object):
	"""
	Reads the data provided, sorts the lines and prints them back out
	(keeps all input in memory until EOF is encountered - then output begins)
	"""
	def __init__(self):
		self.log = app_log().getChild('App')
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

		##
		## Specific init items
		##
		self.projects = {}
		self.build_data = { 'summary':[], 'env':{} }

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

		##
		## Here are the options specific to this cmd-line script
		##
		parser.add_argument("buildlog",
							help="Specify the build log file")
		parser.add_argument("-p", "--proj-num", default=None,
							help="Specify the project to process (vs whole log)")


		##
		## Next, run the parser and save the arguments to our data members
		##
		self.args, self.unknown_args = parser.parse_known_args(args=user_args)

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
		if not os.path.exists(self.args.buildlog):
			raise Exception("Specified build log does not exist [{}]".format(self.args.buildlog))

		##
		## Here we return the options in case 'main' wants them
		##
		if want_unknowns:
			return self.args, self.unknown_args
		return self.args

	def DoWork(self):
		with open(self.args.buildlog, "r") as log:
			self._dowork(log)
		self._write_processed_lines()
		return 0

	class Project(object):
		def __init__(self, proj_num):
			self.proj_num = proj_num
			self._output = {}
			self._def_time = datetime.datetime.strptime('00', '%H')
			self._cur_time = self._def_time
			self.path = None

		def set_path(self, path):
			if path is not None:
				if self.path is not None:
					assert self.path == path
				else:
					self.path = path

		def set_current_time(self, time):
			if time is not None:
				time = datetime.datetime.strptime(time, '%H:%M:%S.%f')
				if time not in self._output:
					self._output[time] = []
				self._cur_time = time

		def add_line(self, ln):
			if self._cur_time not in self._output:
				self._output[self._cur_time] = []
			self._output[self._cur_time].append(ln)

		def output(self):
			if self._def_time in self._output.keys():
				assert len(self._output.keys()) == 1
				for ln in self._output[self._def_time]:
					yield ln
			else:
				for time in sorted(self._output.keys()):
					for ln in self._output[time]:
						yield ln

	def _dowork(self, log_obj):
		# 10:45:36.915  18:2>Done building target "AfterBuild" in project "Win8VS2011.proj".: (TargetId:590)

		
		state = {}
		def exit_proj():
			if 'curproj' in state:
				del state['curproj']

		def make_key(proj, subproj):
			if subproj:
				return (int(proj), int(subproj))
			return (int(proj), 0)

		def start_proj(time, proj, subproj, projpath):
			key = make_key(proj, subproj)
			if key not in self.projects:
				self.projects[key] = App.Project(proj)
			self.projects[key].set_path(projpath)
			self.projects[key].set_current_time(time)
			state['curproj'] = self.projects[key]

		def save_line(ln):
			if 'curproj' not in state:
				self.build_data['summary'].append(ln)
			elif self.args.proj_num is None or self.args.proj_num == state['curproj'].proj_num:
				state['curproj'].add_line(ln)


		# NOTE:  the only time the project path is reliably output is on the last line
		#        produced by that project, with the phrase:  Done Building Project ...
		rx_proj = re.compile(r'^([\d:.]+)?\s+(\d+)(?::(\d+))?>(?:Done Building Project "(.*?)")?')
		rx_env = re.compile(r'^(\w+) = (.*)$')
		rx_msg = re.compile(r'^(Build |Time Elapsed|\w.*Summary:)')
		last = None
		for line in log_obj:
			ln = line.rstrip()

			m = rx_env.match(ln)
			if m:
				(k,v) = m.groups()
				self.build_data['env'][k] = v
				continue

			m = rx_msg.match(ln)
			if m:
				exit_proj()
			else:
				m = rx_proj.match(ln)
				if m:
					start_proj(*m.groups())

			save_line(ln)

		# At this point, the last lines are not project lines, so we should not have a current project
		assert 'curproj' not in state


	def _write_processed_lines(self):
		(bdir, bfile) = os.path.split(self.args.buildlog)
		(bname, bext) = os.path.splitext(bfile)
		if self.args.proj_num:
			proj = self.projects[(int(self.args.proj_num), 0)]
			# Just in case the MS build log is analyzed on non-windows machine...
			# NOTE: that `os.path.normpath()` does NOT convert '\' into '/'
			#       (even though it does to the opposite in windows environments)
			if '\\' in proj.path:
				proj.path = proj.path.replace('\\', '/')
			proj_id = os.path.splitext(os.path.basename(proj.path))[0]
			outfile = os.path.join(bdir, '{}.{}-only{}'.format(bname, proj_id, bext))
		else:
			outfile = os.path.join(bdir, '{}.sorted{}'.format(bname, bext))
		with open(outfile, 'w') as out:
			for key in sorted(self.projects.keys()):
				for ln in self.projects[key].output():
					out.write(ln + '\n')
			out.write('\n' + '\n'.join(self.build_data['summary']) + '\n')

		if self.build_data['env']:
			outfile = os.path.join(bdir, '{}.env{}'.format(bname, bext))
			with open(outfile, 'w') as out:
				for var in sorted(self.build_data['env'].keys()):
					val = self.build_data['env'][var]
					out.write('{} = {}\n'.format(var, val))



## This is the main function, called from below
def main():
	logging.getLogger().addHandler(logging.NullHandler())

	## Initialize the application object, and parse the command line
	## (see App for all the work done here)
	app = App()
	args = app.parseCmdLine()

	return app.DoWork()


##
## Now do the main work!
##
if __name__ == '__main__':
	sys.exit(main())

