#!/usr/bin/env python2
from __future__ import print_function

import sys, os, re, logging, inspect, argparse
from pprint import pprint, pformat

# Disable PYC files for our user-modules
sys.dont_write_bytecode = True


def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def app_log():
	return logging.getLogger(__name__ if __name__ != '__main__' else os.path.splitext(os.path.basename(__file__))[0])
app_log().setLevel(logging.DEBUG)

def run_child(cmdargs, exp_rc=0, *args, **kwargs):
	app_log().info('Running:  {}'.format(cmdargs))
	proc = subprocess.Popen(cmdargs, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, *args, **kwargs)
	(stdout, _) = proc.communicate()
	if exp_rc is not None and proc.returncode != exp_rc:
		stdout_msg = '\n\t'.join(stdout.split('\n')).rstrip() if stdout else 'None'
		eprint('...cmd returned non-zero\n    stdout:\n\t{}\n'.format(stdout_msg))
		if raise_on_ec:
			raise RuntimeError('child process exited with non-zero value:  {}'.format(proc.returncode))
	return (proc.pid, proc.returncode, stdout)

def f(instr):
	if '{' not in instr: return instr
	try:
		myframe = inspect.currentframe()
		caller_locals = myframe.f_back.f_locals
		def repl(mobj):
			return eval(mobj.group(1), globals(), caller_locals)
		while re.search(r'\{[^}]+\}', instr):
			newstr = instr
			try:
				newstr = re.sub(r'\{([^}]+)\}', repl, instr)
			except:
				pass
			if newstr == instr:
				break
			instr = newstr
		if re.search(r'\{[^}]+\}', instr):
			raise Exception("String was not fully substituted:  {}".format(instr))
		return instr
	finally:
		del myframe

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
			return sys.stdin
		return sys.stdout
	def __exit__(self, exception_type, exception_value, traceback):
		if self.fh:
			self.fh.close()
			self.fh = None

def delimited_reader(fobj, delim=None, keep=False, buffersize=10000):
	lines = ['']
	# With 'keeper' we allow our main loop to set aside some
	# some data to be processed on the next iteration
	keeper = ''
	#
	# This allows delimiters to be handled correctly when the next chunk ends
	# right next to or even in the middle of a multi-character delimiter
	# (multi-character example:   line endings on Windows & MAC)
	#
	def getnext():
		return keeper + fobj.read(buffersize)
	for data in iter(getnext, ''):
		#print('just read:  [{}]  (keeper: [{}])'.format(repr(data), repr(keeper)))
		had_data = data != keeper
		data = lines[-1] + data
		keeper = ''

		## Do the splitting
		if delim is None:
			#print('    processing:  [{}]'.format(repr(data)))
			if had_data:
				pos = len(data)
				while data[pos - 1] in ['\n','\r']:
					pos -= 1
				keeper = data[pos:]
				data = data[:pos]
			#print('    about to split:  [{}]  (keeper: [{}])'.format(repr(data), repr(keeper)))
			lines = data.splitlines(keep)
			#print('    leftover:        [{}]'.format(repr(lines[-1])))
		else:
			lines = data.split(delim)
			if keep:
				lines = [l+delim for l in lines[:-1]] + [lines[-1]]
		## Do the returning, err, yielding :)
		for line in lines[:-1]:
			yield line
	if len(lines[-1]):
		yield lines[-1]

def run(cargs):
	with opener(cargs.infile, 'r') as infile:
		for chunk in delimited_reader(infile, delim='\n', keep=True, buffersize=2):
			if not cargs.no_print:
				print('[{}]'.format(repr(chunk)))
	return 0

def main():
	logging.getLogger().addHandler(logging.NullHandler())

	parser = argparse.ArgumentParser(description="Scan a folder recursively for text vs binary files (by type)")
	parser.add_argument("code",
						help="specify the code to run against each line of the input")
	parser.add_argument("infile", nargs='?', default=None,
						help="specify the input file (stdout is used if not specified)")
	parser.add_argument("-n", "--no-print",
						help="do not automatically print each line")
	parser.add_argument("-k", "--keep-ends", action="store_true",
						help="include the line endings in the current line")
	parser.add_argument("--show-args", action="store_true", dest="show_args",
						help="<internal>")

	known_args, unknown_args = parser.parse_known_args()
	if known_args.show_args:
		lines = pformat(known_args, indent=4).splitlines()
		args_str = '\n'.join(["    " + ln for ln in lines])
		print("Args:\n{}".format(args_str))
		return 0

	return run(known_args)


if __name__=='__main__':
	sys.exit(main())

