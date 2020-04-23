#!/usr/bin/env python

import sys, os

class Unbuffered(object):
	"""
	Idea from:  http://stackoverflow.com/a/107717/5844631
	"""
	def __init__(self, stream):
		self.stream = stream
	def write(self, data):
		self.stream.write(data)
		self.stream.flush()
	def __getattr__(self, attr):
		return getattr(self.stream, attr)

def do_work(fh):
	line = fh.readline()
	while line:
		line = line.rstrip()
		print("Got:  [{}]".format(line))
		line = fh.readline()

def main():
	sys.stdout = Unbuffered(sys.stdout)
	sys.stderr = Unbuffered(sys.stderr)

	fifo_name = '/tmp/test.fifo'
	if os.path.exists(fifo_name):
		os.remove(fifo_name)
	os.mkfifo(fifo_name)
	with open(fifo_name, "r") as fh:
		do_work(fh)
	os.remove(fifo_name)

if __name__ == '__main__':
	main()
