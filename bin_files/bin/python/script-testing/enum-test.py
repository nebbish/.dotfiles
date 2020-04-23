#!/usr/bin/env python

import pdb
from functools import wraps

class booya(object):
	def method(self):
		print('booya::method was called')

bobj = booya()
bobj.method()

##
## This open source code is not used much yet
##
def enum(*sequential, **named):
    """
    Create enumeration-like classes, see:  http://stackoverflow.com/questions/36932/how-can-i-represent-an-enum-in-python
    A possibly better (yet heavier) recipe is here:  http://code.activestate.com/recipes/67107/
    """
    enums = dict(zip(sequential, range(len(sequential))), **named)
    ks = list(sequential) + named.keys()
    reverse = dict((value, key) for key, value in enums.iteritems())
    enums['reverse_mapping'] = reverse
    enums['vals'] = staticmethod(lambda: (enums[k] for k in ks))
    return type('Enum', (), enums)

pdb.set_trace()

bobj.method()
