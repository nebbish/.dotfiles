#!/usr/bin/env python

import os, sys
import logging,logging.handlers

#def mod_log(): return logging.getLogger(__name__ if __name__ != '__main__' else '')
def mod_log(): return logging.getLogger(__name__)
#logging.getLogger().setLevel(logging.DEBUG)
#mod_log().setLevel(logging.DEBUG)
#mod_log().addHandler(logging.NullHandler())

def setup_file_logger(path, logname='', lvl=None):
	fh = logging.FileHandler(path)
	if lvl is not None:
		fh.setLevel(lvl)
	#fh.setFormatter(logging.Formatter('%(asctime)s : %(threadName)-10s : %(name)-25s : %(levelname)-8s : %(message)s'))
	fh.setFormatter(logging.Formatter('%(name)-25s : %(levelname)-8s : %(message)s'))
	# Use the root logger if we were not given one to use
	logging.getLogger(logname).addHandler(fh)

def setup_console_logger(logname='', lvl=None):
	sh = logging.StreamHandler(sys.__stdout__)
	if lvl is not None:
		sh.setLevel(lvl)
	sh.setFormatter(logging.Formatter('%(name)-25s : %(levelname)-8s : %(message)s'))
	# Use the root logger if we were not given one to use
	logging.getLogger(logname).addHandler(sh)

def setup_rotating_logger(path, max_size, file_count, logname='', lvl=None):
	rh = logging.handlers.RotatingFileHandler(path, maxBytes=max_size, backupCount=file_count)
	if lvl is not None:
		rh.setLevel(lvl)
	#rh.setFormatter(logging.Formatter('%(asctime)s : %(threadName)-10s : %(name)-25s : %(levelname)-8s : %(message)s'))
	rh.setFormatter(logging.Formatter('%(name)-25s : %(levelname)-8s : %(message)s'))
	# Use the root logger if we were not given one to use
	logging.getLogger(logname).addHandler(rh)

def main():
	setup_console_logger()
	#setup_file_logger('child.log', 'child')

	def logall(logger):
		logger.debug('debug msg')
		logger.info('info msg')
		logger.warning('warning msg')
		logger.error('error msg')
		logger.critical('critical msg')

	logall(mod_log())
	logall(mod_log().getChild('child'))
	logall(logging.getLogger('child'))
	logall(logging.getLogger())

	return 0

if __name__ == '__main__':
	sys.exit(main())

