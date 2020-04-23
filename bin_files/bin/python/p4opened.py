#!/usr/bin/env python2
from __future__ import print_function
import sys, os, re, argparse
import subprocess
from pprint import pprint,pformat

def run_child(cmdargs, exp_rc=None, *args, **kwargs):
	proc = subprocess.Popen(cmdargs, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, *args, **kwargs)
	(stdout, _) = proc.communicate()
	if exp_rc is not None and exp_rc != proc.returncode:
		stdout_msg = '\n\t'.join(stdout.split('\n')).rstrip() if stdout else 'None'
		print('...cmd exited [{}], but [{}] was epxected\n    stdout:\n\t{}\n'.format(proc.returncode, exp_rc, stdout_msg))
		raise RuntimeError('child process exited with non-zero value:  {}'.format(proc.returncode))
	return (proc.returncode, stdout)

def process_request(pathspec, ignore_list):
	(rc, out) = run_child(['p4', 'opened'] + ([pathspec] if pathspec else []))
	#print(out)

	results = {}
	for ln in out.splitlines():
		m = re.search(r'^(//depot.*?)#(\d+) - (\w+) \w+ (change|\d+)', ln)
		if not m: continue
		(path, rev, action, cl) = m.groups()
		if cl == 'change':
			cl = 'default'

		## Keeping it lowercase for sorting of the output
		if cl in results:
			results[cl] = sorted(results[cl] + [ln.lower()])
		else:
			results[cl] = [ln.lower()]

	print()
	for cl in sorted(results.keys(), key=lambda x: '0' if x == 'default' else x):
		if cl in ignore_list:
			continue
		pprint({cl: results[cl]})
		print()

def main():
	ignore_list = []
	parser = argparse.ArgumentParser(description="Scan a folder recursively for text vs binary files (by type)")
	parser.add_argument("path", nargs="?", default=None,
						help = 'Specify the files expression for the P4 cmd "opened"')
	parser.add_argument("-i", "--ignore", nargs='*', default=ignore_list,
						help="specify CLs that should be ignored in the query")
	parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")

	args = parser.parse_args()
	if args.show_args:
		lines = pformat(args, indent=4).splitlines()
		args_str = '\n'.join(["    " + ln for ln in lines])
		print("Args:\n{}".format(args_str))
		sys.exit(0)

	process_request(args.path, args.ignore)
	return 0


if __name__ == '__main__':
	sys.exit(main())

