#!/usr/bin/env python3
from plumbum import cli
import os, sys, glob

def search(pat, cur=os.getcwd()):
	files = []
	while cur:
		#print('checking {}'.format(cur))
		glob_expr = os.path.join(cur, pat)
		#print('looking for:  {}'.format(glob_expr))
		files += glob.glob(glob_expr)
		#files += [os.path.join(cur, i) for i in os.listdir(cur) if i == '.clang-format']
		parent = os.path.dirname(cur)
		if parent == cur: break
		cur = parent
	if files:
		print("\n\t{}".format("\n\t".join(files)))
	return 0

class App(cli.Application):
    """This will search for the specified file in both the specified directory
    AND the parent of that directory, looping and searching each parent until
    the root is encountered and printing all of the results"""

    VERSION = "1.0"

    start = cli.SwitchAttr(["-s", "--start"], str, default=os.getcwd(),
                           help="Specify the location to start the upwards search")

    def main(self, glob):
        return search(glob, self.start)


if __name__ == '__main__':
    App.run()

