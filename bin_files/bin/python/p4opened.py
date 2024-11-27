#!/usr/bin/env python3
from plumbum import local
from plumbum.cmd import p4, cmd

import sys, os, re, argparse
from pprint import pprint,pformat

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def gather_cl_info(cl):
	cl_args = [] if cl == 'default' else [cl]
	info = p4['change', '-o'][cl_args]()
	data = {
			'all': info,
			'desc': re.search(r'Description:.*[\n\r]*((?:\t.*[\n\r]+)+)', info).group(1).rstrip(),
			'spec': re.search(r'^Client:[ \t]+(.*)', info, re.M).group(1).rstrip()
		}
	return data

def process_client(cargs, client):
	with local.env(P4CLIENT=client):
		p4_args = [cargs.path] if cargs.path else []
		out = p4['opened'][p4_args]()
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
		if cl in cargs.ignore_list:
			continue

		output = { cl : results[cl] }

		# Optionally print a description for this CL before pprint'ing the dictionary
		if cargs.descriptions:
			print(gather_cl_info(cl)['desc'])

		pprint(output)
		print('\n\n')

def p4_info():
	# On a fresh system, I learned that there CAN be a line returned without a colon:
	#    "Client unknown."
	# so...  I added a filter below to skip lines without colons

	lines = p4['info']().strip().splitlines()
	pairs = [i.split(':',1) for i in lines if ':' in i]
	return {k.strip():v.strip() for (k,v) in pairs}
p4info = p4_info()

def main():
	ignore_list = []
	parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
									 description="Scan a folder recursively for text vs binary files (by type)")
	parser.add_argument("path", nargs="?", default=None,
						help = 'Specify the files expression for the P4 cmd "opened"')
	parser.add_argument("-d", "--descriptions", action="store_true",
						help="include the CL descriptions in the output")
	parser.add_argument("-i", "--ignore-list", nargs='*', default=ignore_list,
						help="specify CLs that should be ignored in the query")
	parser.add_argument("--all-clients", action="store_true",
						help="show opened files on all clients")
	parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")

	cargs = parser.parse_args()
	if cargs.show_args:
		lines = pformat(cargs, indent=4).splitlines()
		args_str = '\n'.join(["    " + ln for ln in lines])
		print("Args:\n{}".format(args_str))
		sys.exit(0)


	clients = []
	if cargs.all_clients:
		import socket
		thishost = socket.gethostname().lower()
		out = p4['clients', '-u', p4info['User name']]()
		for cli_line in out.splitlines():
			cli = cli_line.split()[1]
			clidata = p4['client', '-o', cli]()

			# Filter out clients that DO specify a host, and it is NOT the current host
			# NOTE:  this re will pick up CR characters :( -- hence the .rstrip() below
			mhost = re.search(r'^Host:\s*(\S.*)$', clidata, re.M)
			if mhost:
				if mhost.group(1).rstrip().lower() != thishost:
					eprint(f"skipping client {cli} with host entry for a different computer:  {mhost.group(1)}")
					continue

			clients.append(cli)
	elif p4info['Client name'] == p4info['Client host']:
		print("No current P4CLIENT defined, nothing to do")
	else:
		clients.append(p4info['Client name'])

	for cli in clients:
		if len(clients) > 1:
			print(f"{cli}\n{'='*len(cli)}")
		process_client(cargs, cli)

	return 0


if __name__ == '__main__':
	sys.exit(main())

