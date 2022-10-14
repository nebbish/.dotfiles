#!/usr/bin/env python2
import os, sys, platform, stat, datetime, argparse, shutil

def creation_date(path_to_file):
    """
    Try to get the date that a file was created, falling back to when it was
    last modified if that isn't possible.
    See http://stackoverflow.com/a/39501288/1709587 for explanation.
    """
    if platform.system() == 'Windows':
        return os.path.getctime(path_to_file)
    else:
        stat = os.stat(path_to_file)
        try:
            return stat.st_birthtime
        except AttributeError:
            # We're probably on Linux. No easy way to get creation dates here,
            # so we'll settle for when its content was last modified.
            return stat.st_mtime

def main():
	parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
	                                 description="Rename/Copy specified file, adding the file mod/cre time as a suffix/prefix")
	parser.add_argument("path",
						help = "Specify the file to work with")
	parser.add_argument("-c", "--copy", action="store_true",
						help="If specified a copy will be made (vs just renaming the original)")
	parser.add_argument("-p", "--prefix", action="store_true",
						help="Prepend the calculated date (vs append which is default)")
	parser.add_argument("-f", "--format", default="%Y_%m_%d_%H_%M_%S",
						help="Specify the format string for the date (see 'strftime')")
	parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")

	cargs = parser.parse_args()
	if cargs.show_args:
		lines = pformat(cargs, indent=4).splitlines()
		args_str = '\n'.join(["    " + ln for ln in lines])
		print("Args:\n{}".format(args_str))
		sys.exit(0)

	assert os.path.exists(cargs.path)
	timestamp = creation_date(cargs.path)
	time_str = datetime.datetime.fromtimestamp(timestamp).strftime(cargs.format)

	(dir_arg, fname_arg) = os.path.split(cargs.path)
	if cargs.prefix:
		new_path = os.path.join(dir_arg, time_str + '_' + fname_arg)
	else:
		new_path = os.path.join(dir_arg, fname_arg + '_' + time_str)

	if cargs.copy:
		shutil.copy(cargs.path, new_path)
	else:
		os.rename(cargs.path, new_path)
	return 0

if __name__ == '__main__':
	sys.exit(main())

