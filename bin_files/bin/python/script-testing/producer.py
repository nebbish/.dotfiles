#!/usr/bin/env python

import sys, os, cmd

class CLI(cmd.Cmd):
	def __init__(self, fh):
		#super(CLI, self).__init__()
		cmd.Cmd.__init__(self)
		self.fh = fh
		self.prompt = '> '

	def do_send(self, *args):
		line = ' '.join(args)
		fh.write(line + '\n')
		fh.flush()
		print("Sent [{}]".format(line))

	def help_send(self):
		print("syntax: send [word] [word] [word]...")
		print("-- sends a message through the FIFO")

	def do_hello(self, arg):
		print("Hello again {}!".format(arg))

	def help_hello(self):
		print("syntax: hello [message]")
		print("-- prints a hello message")

	def do_quit(self, arg):
		sys.exit(arg)

	def help_quit(self):
		print("syntax: quit [returncode]")
		print("-- terminates the application")

	# shortcuts
	do_s = do_send
	do_q = do_quit

fifo_name = '/tmp/test.fifo'
with open(fifo_name, "w") as fh:
	cli = CLI(fh)
	cli.cmdloop()

