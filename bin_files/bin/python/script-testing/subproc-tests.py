#!/usr/bin/env python2
from __future__ import print_function

import os, sys, logging, subprocess, inspect, argparse, collections
import re
import imp
import cmd
from pprint import pprint, pformat
import pdb



# Disable PYC files for our user-modules
sys.dont_write_bytecode = True

def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def app_log():
	return logging.getLogger(__name__ if __name__ != '__main__' else os.path.splitext(os.path.basename(__file__))[0])
app_log().addHandler(logging.NullHandler())

def popen(*args, **kwargs):
	app_log().info('Running:  {} (kwargs: {})'.format(args, kwargs))
	proc = subprocess.Popen(*args, **kwargs)
	# Here we attach a little something so the 'wait' helper can build a helpful error if things go wrong
	proc.__dict__['popenargs'] = args
	return proc

def check_wait(proc, exp_rc=None, input=None):
	(stdout, stderr) = proc.communicate(input=input)
	def indent(msg):
		if not msg: return '\t<None>'
		return '\t' + '\n\t'.join(msg.splitlines())
	app_log().debug('rc={}'.format(proc.returncode))
	app_log().debug('stderr=\n{}'.format(indent(stderr)))
	app_log().debug('stdout=\n{}'.format(indent(stdout)))
	if exp_rc is not None and exp_rc != proc.returncode:
		prt_msg = stderr
		if not prt_msg: prt_msg = stdout
		if not prt_msg: prt_msg = 'None'
		eprint('...cmd returned non-zero:{}'.format('\n\t'.join([''] + prt_msg.splitlines())))
		exc_msg = '\n'.join([stdout, stderr]) if stderr else stdout
		# If our own function 'popen(...)' was used, then this extra attribute will be there
		cmd = proc.popenargs if hasattr(proc, 'popenargs') else None
		raise subprocess.CalledProcessError(proc.returncode, cmd, exc_msg)
	return (proc.pid, proc.returncode, stdout, stderr)

def call(*popenargs, **kwargs):
	proc = popen(*popenargs, **kwargs)
	(pid, rc, stdout, stderr) = check_wait(proc, exp_rc=None)
	return rc

def call_output(*popenargs, **kwargs):
	if 'stdout' in kwargs:
	    raise ValueError('stdout argument not allowed, it will be overridden.')
	kwargs['stdout'] = subprocess.PIPE
	proc = popen(*popenargs, **kwargs)
	(pid, rc, stdout, stderr) = check_wait(proc, exp_rc=None)
	return rc, '\n'.join([stdout, stderr]) if stderr else stdout

def check_call(*popenargs, **kwargs):
	proc = popen(*popenargs, **kwargs)
	(pid, rc, stdout, stderr) = check_wait(proc, exp_rc=0)
	return

def check_output(*popenargs, **kwargs):
	if 'stdout' in kwargs:
		raise ValueError('stdout argument not allowed, it will be overridden.')
	kwargs['stdout'] = subprocess.PIPE
	proc = popen(*popenargs, **kwargs)
	(pid, rc, stdout, stderr) = check_wait(proc, exp_rc=0)
	return '\n'.join([stdout, stderr]) if stderr else stdout

class CompletedProcess(object):
	def __init__(self, cmd, returncode, stdout, stderr):
		self._cmd = cmd
		self._returncode = returncode
		self._stdout = stdout
		self._stderr = stderr
	@property
	def cmd(self):
		return self._cmd
	@property
	def returncode(self):
		return self._returncode
	@property
	def stdout(self):
		return self._stdout
	@property
	def stderr(self):
		return self._stderr
	def check_returncode(self):
		if self._returncode != 0:
			raise subprocess.CalledProcessError(self._returncode, self._cmd, self._stdout)

def run(*popenargs, **kwargs):
	"""Really like the python3 subprocess.run(...) signature, but returning a custom CompletedProcess object"""
	capture = kwargs.pop('capture_output', False)
	if capture:
		if 'stdout' in kwargs:
			raise ValueError('stdout argument not allowed, it will be overridden.')
		if 'stderr' in kwargs:
			raise ValueError('stderr argument not allowed, it will be overridden.')
		kwargs['stdout'] = subprocess.PIPE
		kwargs['stderr'] = subprocess.PIPE

	if 'universal_newlines' not in kwargs:
		kwargs['universal_newlines'] = True

	input = kwargs.pop('input', None)
	if input is not None:
		if 'stdin' in kwargs:
			raise ValueError('stdin and input arguments may not both be used.')
		kwargs['stdin'] = subprocess.PIPE

	check = kwargs.pop('check', False)
	exp_rc = None
	if isinstance(check, bool):
		exp_rc = 0 if check else None
	elif isinstance(check, int):
		exp_rc = check

	proc = popen(*popenargs, **kwargs)
	(pid, rc, stdout, stderr) = check_wait(proc, exp_rc=exp_rc, input=input)
	return CompletedProcess(popenargs, rc, stdout, stderr)




def process_args():
	parser = argparse.ArgumentParser(description="Pass all provided arguments directly into subprocess.Popen")
	parser.add_argument("popen_args", nargs='+')
	parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")
	known_args, unknown_args = parser.parse_known_args()
	pprint(unknown_args)

	kwargs = {}
	idx = 0
	while idx < len(unknown_args):
		arg = unknown_args[idx]
		idx += 1
		if arg.startswith('--'):
			(k,v) = arg.split('=',1)
			kwargs[k.lstrip('-')] = v
		elif arg.startswith('-'):
			idx += 1
			assert(idx < len(unknown_args))
			(k,v) = (arg, unknown_args[idx])
			kwargs[k.lstrip('-')] = v
		else:
			raise Exception('unexpected')

	return known_args.popen_args, kwargs

def main():
	app_log().setLevel(logging.DEBUG)
	# This will default to STDERR without specifying
	sh = logging.StreamHandler(sys.stdout)
	sh.setLevel(logging.INFO)
	app_log().addHandler(sh)

	popen_args, kwargs = process_args()

	# pdb.set_trace()
	print('Using "popen(...):" and our own call of proc.communicate()')
	proc = popen(popen_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, **kwargs)
	(stdout, _) = proc.communicate()
	stdout_msg = '\n    '.join(stdout.split('\n')).rstrip() if stdout else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(proc.returncode, stdout_msg))

	print('Using "check_output(...):"')
	stdout = check_output(popen_args, **kwargs)
	stdout_msg = '\n    '.join(stdout.split('\n')).rstrip() if stdout else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(proc.returncode, stdout_msg))

	print('Using "check_output(..., stderr=PIPE, ...):"')
	stdout = check_output(popen_args, stderr=subprocess.PIPE, **kwargs)
	stdout_msg = '\n    '.join(stdout.split('\n')).rstrip() if stdout else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(proc.returncode, stdout_msg))

	print('Using "check_output(..., stderr=STDOUT, ...):"')
	stdout = check_output(popen_args, stderr=subprocess.STDOUT, **kwargs)
	stdout_msg = '\n    '.join(stdout.split('\n')).rstrip() if stdout else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(proc.returncode, stdout_msg))

	print('Using "check_call(...):"')
	stdout = check_call(popen_args, **kwargs)
	stdout_msg = '\n    '.join(stdout.split('\n')).rstrip() if stdout else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(proc.returncode, stdout_msg))

	print('Using "run(...):"')
	obj = run(popen_args, **kwargs)
	stdout_msg = '\n    '.join(obj.stdout.split('\n')).rstrip() if obj.stdout else 'None'
	stderr_msg = '\n    '.join(obj.stderr.split('\n')).rstrip() if obj.stderr else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(obj.returncode, stdout_msg))
	print('                  stderr:\n    {}\n'.format(stderr_msg))

	print('Using "run(..., capture_output=True):"')
	obj = run(popen_args, capture_output=True, **kwargs)
	stdout_msg = '\n    '.join(obj.stdout.split('\n')).rstrip() if obj.stdout else 'None'
	stderr_msg = '\n    '.join(obj.stderr.split('\n')).rstrip() if obj.stderr else 'None'
	print('cmd returned [{}], stdout:\n    {}\n'.format(obj.returncode, stdout_msg))
	print('                  stderr:\n    {}\n'.format(stderr_msg))

	return proc.returncode

##
## Now do the main work!
##
if __name__ == '__main__':
	sys.exit(main())


