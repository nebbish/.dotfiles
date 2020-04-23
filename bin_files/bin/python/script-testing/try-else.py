#!/usr/bin/env python

import sys
import time
import pdb

def reraise_intended_exit():
	import bdb
	intended_exit_types = [ KeyboardInterrupt, SystemExit, bdb.BdbQuit ]
	if any([isinstance(sys.exc_info()[1], iet) for iet in intended_exit_types]):
		mod_log().info('re-raising an "intended exit" type of exception: {0}'.format(sys.exc_info()))
		raise sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2]

def main(arg):
	done = False
	while not done:
		done = True

		try:
			if arg == 'continue':	# skips 'else' clause
				continue
			elif arg == 'break':	# skips 'else' clause
				break
			elif arg == 'return':	# skips 'else' clause
				return
			elif arg == 'except':
				raise Exception('dummy error')
			elif arg == 'sleep':
				# The purpose here for this delay, is to provide a confortable amount of time
				# for the user to press ctrl-c to trigger a KeyboardInterrupt exception.
				time.sleep(300)
		except:
			pdb.set_trace()
			iskb = isinstance(sys.exc_info()[1], KeyboardInterrupt)
			l = len(sys.exc_info())
			typ = type(sys.exc_info()[1])
			name = sys.exc_info()[0].__name__
			name = typ.__name__
			print('except clause... (cnt={} iskb={} type={} name={})'.format(l, iskb, typ, name))

			reraise_intended_exit()
			print('swallowing exception')
		else:
			print('else clause...')
		finally:
			print('finally clause...')

arg = ''
if len(sys.argv) > 1:
	arg = sys.argv[1]

main(arg)

