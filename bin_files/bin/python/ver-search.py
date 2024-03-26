#!/usr/bin/env python3
import sys, os, re
import argparse, inspect
import pdb

class App(object):
	"""
	Search the specified location (defaults to CWD) for source files
	containing the specified 3-digit version
	"""
	def __init__(self, user_args=None):
		parser = argparse.ArgumentParser(description=inspect.getdoc(self))
		parser.add_argument("ver", help="Version to search for")
		parser.add_argument("-r", "--rootdir", default=os.path.relpath(os.getcwd()), help="starting directory for the search")
		cargs = parser.parse_args(args=user_args)

		parts = cargs.ver.split('.')
		assert len(parts) == 3, "The specified version should be 3 parts:  <major>.<minor>.<teeny>"

		self.rootdir = cargs.rootdir
		self.rx_ver = re.compile(r'\b{}\b'.format(cargs.ver.replace('.', r'\.')))
		self.rx_parts = []
		# pdb.set_trace()
		uniq = {}
		for p in parts:
			uniq[p] = uniq[p] + 1 if p in uniq else 1
		for (part,count) in uniq.iteritems():
			self.rx_parts.append((re.compile(r'\b{}\b'.format(part)), count))


	def run(self):
		retval = []
		for root, dirs, files in os.walk(self.rootdir):
			for f in files:
				item = os.path.join(root, f)
				try:
					skip = False
					with open(item, 'r') as fitem:
						data = fitem.read()
					if not self.rx_ver.search(data):
						for (rx, count) in self.rx_parts:
							if len(rx.findall(data)) != count:
								skip = True
					if not skip:
						retval.append(item)
				except:
					pass
		return retval

def main():
	for m in App().run():
		print(m)
	return 0

if __name__ == '__main__':
	sys.exit(main())

