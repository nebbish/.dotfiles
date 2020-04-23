#!/usr/bin/env python

import os, sys, re, logging
import subprocess, threading, datetime, time
import argparse


##
## NOTE:  we have to support Python <= 2.6, which means...
##  1)  Loggers do not have the 'getChild' method
##  2)  The logging module does not come with a NullHandler
##  3)  The 'format()' method *REQUIRES* all of the '{}' to be numbered or named
##  4)  The datetime.timedelta objects do not have a 'total_seconds()' method
##

# Special Logger over-ride for Python <= 2.6
class logger(logging.Logger):
	def getChild(self, name):
		return logging.getLogger("{0}.{1}".format(self.name, name))
logging.setLoggerClass(logger)

# Special NullHandler object for Python <= 2.6
try:
	from logging import NullHandler
except ImportError:
	class NullHandler(logging.Handler):
		def emit(self, record):
			pass
	logging.NullHandler = NullHandler

# Special 'total_seconds' method for Python <= 2.6
def total_seconds(td):
	return (td.microseconds + (td.seconds + td.days * 24 * 3600) * 10**6) / 10**6

##
## Here we prepare our module logger for applications that do not setup a logger
## In those cases, adding a NULL handler will prevent our messages from surprisingly
## all appearing in the applications STDERR stream.
##
def mod_log(): return logging.getLogger(__name__ if __name__ != '__main__' else '')
mod_log().addHandler(logging.NullHandler())

##
## Here we sometimes setup a log file that catches everything from this
## module and any child loggers - just when we need to seriously debug
##
_mod_debug_flag = False
if _mod_debug_flag:
	import inspect
	scriptPath = inspect.getfile(inspect.currentframe())
	scriptDir, scriptName = os.path.split(scriptPath)
	scriptTitle = os.path.splitext(scriptName)[0]
	mod_log().setLevel(logging.DEBUG)
	_mod_dbg_hdlr = logging.FileHandler(os.path.join(scriptDir, scriptTitle + '.dbg.log'))
	_mod_dbg_hdlr.setLevel(logging.DEBUG)
	_mod_dbg_hdlr.setFormatter(logging.Formatter('%(asctime)s : %(threadName)-10s : %(name)-25s : %(levelname)-8s : %(message)s'))
	mod_log().addHandler(_mod_dbg_hdlr)

def reraise_intended_exit():
	import bdb
	intended_exit_types = [ KeyboardInterrupt, SystemExit, bdb.BdbQuit ]
	if any([isinstance(sys.exc_info()[1], iet) for iet in intended_exit_types]):
		mod_log().info('re-raising an "intended exit" type of exception: {0}'.format(sys.exc_info()))
		raise sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2]

class SubProc(object):
	def __init__(self):
		"""
		Create an instance
		"""
		# Setup our logger (it will be a child of this module, so the log messages
		# from this class (base, impl in module) can be distinguished from the
		# the derived class (impl in app PY script).
		self._log = mod_log().getChild('SubProc')
		self._log.debug('__init__(self)')

	def launch(self, command, *args, **kwargs):
		if isinstance(command, basestring):
			cmdstr = command
		elif isinstance(command, list):
			cmdstr = ' '.join(command)
		else:
			raise TypeError("The 'command' value must be a string or list.  Instead got [{0}]".format(type(command)))

		# Calculate a "command name".   We will save it within the object returned by subprocess.Popen
		m = re.match(r'''([\'"])(([^\1\\]|\\.)*?)\1|(\S+)''', cmdstr)
		assert(m)
		cmdname = m.group(4) if m.group(4) else m.group(2)
		# I've checked, and split returns blank for the dir if just a file is passed in
		# (i.e. there are always 2 values returned, index '1' should always work)
		cmdname = os.path.split(cmdname)[1]

		# Now run it, log the PID and return it
		self._log.info('launch("{0}")'.format(cmdname))
		self._log.info('    full cmd: {0}'.format(command))
		proc = None
		try:
			proc = subprocess.Popen(command,
									stdout=subprocess.PIPE,
									stderr=subprocess.PIPE,
									*args, **kwargs)
			proc.cmdname = cmdname
			self._log.info('   launched {0}, pid:  {1}'.format(cmdname, proc.pid))
		except:
			# If the proc was created, and is not finished yet... kill it
			if proc and proc.poll() is None:
				self._log.exception('exception running {0} and it is still running, sending kill signal to pid {1}'.format(cmdname, proc.pid))
				import signal
				os.kill(proc.pid, signal.SIGKILL)
			raise
		return proc

	def waitForProc(self, proc, logdir=None, logpath=None, echo=True, timeout=-1, raise_on_ec=False, echo_filter=None, echo_prefix=None):
		"""
		This method is designed to work with launch().
		The object returned from launch(...), which is the same one returned
		by subprocess.Popen within launch(...), is the object that gets passed
		into this method in order to wait for the child process to complete,
		while continually reading the child process's stdout/stderr streams.

		This method uses the other arguments to control what happens to each
		line of stdout/stderr that is processed, and to control how to respond
		to "error conditions" (either non-zero exit code -or- timeout)
		"""
		self._log.debug('waitForProc(self={0}, proc="{1}", logdir="{2}", logpath="{3}", echo={4}, timeout={5}, echo_filter={6}, echo_prefix="{7}")'.format(self, proc.cmdname, logdir, logpath, echo, timeout, echo_filter, echo_prefix))

		self._log.info("   Waiting for {0} completion...".format(proc.pid))
		## Setup the returned information
		data = {
			'stdout' : [],
			'stderr' : [],
			'cmbout' : [],
		}

		# Here we declare variables that will be used in the 'finally' clause
		logfile = None
		stream_abort = False
		## This lock surrounds all logging/echoing from the monitoring threads
		## to syncronize their output.  This prevents interleaved messages in
		## the console and/or log file.
		echo_lock = threading.Lock()
		log_lock = threading.Lock()

		## Here setup the data to control the thread behavior, some categorical descriptions:
		##  1) *primary:    the stream to read from, and the list object to append it to
		##  2) *secondary:  the echo destination if enabled, and a 'prefix' value to help
		##                  'visually organize' the console output
		##                  also a lock object to prevent interleaved output
		##  3) extra:  a logger object to log the stream data that is not echoed (and prefix)
		##  4) extra:  a 'dump' file handle, which will point to a stream dump file
		##             (if the user specified a logging directory on the cmd-line)
		##
		stream_data = {
				'stdout' : {
					'stream' : proc.stdout,
					'lines' : data['stdout'],
					'cmblist' : data['cmbout'],
					'thread' : None,
					'echo' : sys.stdout,
					'epfx' : str(echo_prefix) if echo_prefix else '{0} (so)...: '.format(proc.pid),
				},
				'stderr' : {
					'stream' : proc.stderr,
					'lines' : data['stderr'],
					'cmblist' : data['cmbout'],
					'thread' : None,
					'echo' : sys.stderr,
					'epfx' : str(echo_prefix) if echo_prefix else '{0} (se)...: '.format(proc.pid),
				},
			}

		try:
			# If either of the logxxx options are set, then setup logging and adjust echo to raw handles
			if logpath is not None:
				if logdir is not None:
					raise ValueError("For the following, 'logdir' and 'logpath', just one should be passed in")
			if logdir is not None:
				logname = '{0}_{1}.log'.format(os.path.basename(proc.cmdname), proc.pid)
				logpath = os.path.join(logdir, logname)
				if os.path.exists(logpath):
					self._log.error('logpath already exists!  raising exception')
					raise Exception('Unexpected child-proc log file already exists here [{0}]'.format(logpath))
			if logpath is not None:
				self._log.info('   logpath {0}'.format(logpath))
				logfile = open(logpath, 'a')
				# Since we will be logging the command output to its own file,
				# use the "original" STDOUT/STDERR that won't be susceptable to interception
				stream_data['stdout']['echo'] = sys.__stdout__
				stream_data['stderr']['echo'] = sys.__stderr__

			## This is the thread procedure
			def stream_proc(sn, sd):
				"""
				This tidy little proc just uses the info from the data block to do everything
				(including closing the logging directory file handle if it was opened for us)
				"""
				line = sd['stream'].readline()
				while line and not stream_abort:
					line = line.rstrip()
					# Handle line...
					sd['lines'].append(line)
					sd['cmblist'].append(line)
					if echo and (not echo_filter or echo_filter(line)):
						with echo_lock as lk:
							sd['echo'].write(sd['epfx'] + line + '\n')
							sd['echo'].flush()
					if logfile:
						with log_lock as lk:
							logfile.write(line + '\n')
							logfile.flush()
					# Next line...
					line = sd['stream'].readline()

			## Now that everything is prepared...finally...launch the threads
			for (sn,sd) in stream_data.iteritems():
				sd['thread'] = threading.Thread(target=stream_proc, args=(sn,sd))
				sd['thread'].daemon = True  # Mark thread so it won't keep Python alive
				sd['thread'].start()


			## Now wait for the *PROCESS* ... *NOT* the threads (through 'join()')
			## Because it is known that -if- a thread-related performance problem exists,
			## calling 'join()' will only increase the problem by orders of magnitude
			start = datetime.datetime.now()
			self._log.debug('   starting delay now [{0}], timeout [{1}]'.format(start, timeout))

			# A negative timeout value will cause this loop to break only when proc is done
			# Any other positive value will also break this loop after that much time has passed
			delay = timeout if timeout >= 0 else -1
			while delay != 0 and proc.poll() is None:
				time.sleep(0.1)
				if delay > 0 and 0 >= (delay - total_seconds(datetime.datetime.now() - start)):
					delay = 0
			self._log.debug('   ...ending delay now [{0}]'.format(datetime.datetime.now()))

			if proc.poll() is not None:
				## Lastly, log the exit code before returning, since we waited for it and all
				self._log.info('   exit code: {0}'.format(proc.returncode))
				if raise_on_ec and proc.returncode:
					msg = '    output:\n{0}'.format('\n\t'.join(data['cmbout'][-30:]))
					raise Exception('Child process [{0}] exited with error [returncode={1}], {2}'.format(proc.cmdname, proc.returncode, msg))
			else:
				self._log.info("   exit code: <unknown>, timed out while waiting (timeout val: {0})".format(timeout))
				if raise_on_ec:
					raise Exception('Child process [{0}] timed out [{1}]'.format(proc.cmdname, timeout))
		except:
			# If the proc was created, and is not finished yet... kill it
			if proc and proc.poll() is None:
				self._log.exception('exception waiting for {0} and it is still running, sending kill signal to pid {1}'.format(proc.cmdname, proc.pid))
				import signal
				os.kill(proc.pid, signal.SIGKILL)
			raise
		finally:
			# Even though we marked these threads as 'daemon' we still try to join and be "clean"
			stream_abort = True
			for (sn,sd) in stream_data.iteritems():
				self._log.info('    waiting for the {0} thread to finish'.format(sn))
				if sd['thread']: sd['thread'].join()
			# And close the logfile if we opened one
			if logfile is not None:
				logfile.close()
				logfile = None
		return proc.returncode, data

	def runBlockCmd(self, command, logdir=None, logpath=None, shell=True, echo=True, timeout=-1, raise_on_ec=True, *args, **kwargs):
		"""
		This method just combinds launch() and waitForProc()

		NOTE:  command can be a string or a list.
			   if 'shell' is True, then it SHOULD be a string
			   if 'shell' is False, then it SHOULD be a list
		"""
		proc = self.launch(command, shell=shell, *args, **kwargs)
		return self.waitForProc(proc, logdir=logdir, logpath=logpath, echo=echo, timeout=timeout, raise_on_ec=raise_on_ec)
subproc = SubProc()

	def main(self, args):
		mod_log().info('running main...')
		print('[main] sys.stdin.isatty() = {0}'.format('True' if sys.stdin.isatty() else 'False'))
		print('[main] sys.stdout.isatty() = {0}'.format('True' if sys.stdout.isatty() else 'False'))
		print('[main] sys.stderr.isatty() = {0}'.format('True' if sys.stderr.isatty() else 'False'))

		cmdlist = [
			'python',
			os.path.join(os.getcwd(), 'child-tty-test.py'),
		]

		if args.ub_py:
			cmdlist.insert(1, '-u')
		if args.pdb_obj:
			cmdlist += ['--pdb_obj']
		if args.ub_std:
			cmdlist += ['--ub_std']
		if args.sleep is not None:
			cmdlist += ['--sleep', args.sleep]
		if args.tty_std:
			cmdlist += ['--tty_std']
		
		cmd = ' '.join(cmdlist)
		print('main launching child: "{0}"'.format(cmd))
		if args.raw_call:
			subprocess.check_call(cmd, shell=True)
		else:
			subproc.runBlockCmd(cmd, logname='log-child.log')
		return 0

def setup_console_logger(logname='', lvl=None):
	sh = logging.StreamHandler(sys.__stdout__)
	if lvl is not None:
		sh.setLevel(lvl)
	sh.setFormatter(logging.Formatter('%(name)-25s : %(levelname)-8s : %(message)s'))
	# Use the root logger if we were not given one to use
	logging.getLogger(logname).addHandler(sh)

def main():
	ap = argparse.ArgumentParser(add_help=True)
	ap.add_argument("--ub_py", dest="ub_py", action="store_true", help="launch child python with '-u' switch (for unbuffered i/o)")
	ap.add_argument("--raw_call", dest="raw_call", action="store_true", help="use subprocess.check_call() instead of custom wrapper")
	ap.add_argument("--pdb_obj", dest="pdb_obj", action="store_true", help="use Pdb object with explicit 'tty' stdout")
	ap.add_argument("--ub_std", dest="ub_std", action="store_true", help="setup the stdout/stderr to be unbuffered")
	ap.add_argument("--sleep", dest="sleep", default=None, help="sleep for this many seconds (prior to 2nd round of printing)")
	ap.add_argument("--tty_std", dest="tty_std", action="store_true", help="setup the stdout/stderr to be *direct* to TTY (prior to 2nd round of printing")
	args = ap.parse_args()
	app = SubProc()
	return app.main(args)

if __name__ == '__main__':
	sys.exit(main())

